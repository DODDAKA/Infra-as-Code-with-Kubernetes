
resource "azurerm_user_assigned_identity" "medadv360-terraform-app" {
  name                = "medadv360-terraform-app"
  resource_group_name = data.azurerm_resource_group.rg-dnk-hub-cus.name
  location            = data.azurerm_resource_group.rg-dnk-hub-cus.location
}
### Identity role assignment
resource "azurerm_role_assignment" "dns_contributor" {
  scope = data.azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.medadv360-terraform-app.principal_id
}

resource "azurerm_role_assignment" "app-gw-contributor" {
  scope                = data.terraform_remote_state.remote-hub-state-file.outputs.xclient-app-gw-id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aksspoke.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
resource "azurerm_role_assignment" "appgw-contributor" {
  scope                = data.terraform_remote_state.remote-hub-state-file.outputs.appgw-hub-subnet-id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aksspoke.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}


resource "azurerm_kubernetes_cluster" "aksspoke" {
  name                = "aksspoke"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksspoke"
  private_dns_zone_id = data.azurerm_private_dns_zone.aks.id
  default_node_pool {
    name           = var.default_node_pool_name
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = azurerm_subnet.snet_1.id
    zones          = var.default_node_pool_availability_zones
    auto_scaling_enabled    = true
    host_encryption_enabled = false
    node_public_ip_enabled  = true
    max_pods                = var.default_node_pool_max_pods
    max_count               = var.default_node_pool_max_count
    min_count               = var.default_node_pool_min_count
    node_count              = var.default_node_pool_node_count
    os_disk_type            = var.default_node_pool_os_disk_type
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "dev"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.medadv360-terraform-app.id ]
  }

  tags = {
    Environment = "Production"
  }

 #azure_policy_enabled = true
 ingress_application_gateway {
    gateway_id = data.terraform_remote_state.remote-hub-state-file.outputs.xclient-app-gw-id
 } 
 kubernetes_version = var.kubernetes_version
 private_cluster_enabled = true
 sku_tier = var.sku_tier

 linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.SSH_PUBLIC_KEY
    }
  }

 azure_active_directory_role_based_access_control {
    #  managed            = true
    azure_rbac_enabled = true
    tenant_id          = var.tenant_id
  }

 network_profile {
    dns_service_ip    = var.network_dns_service_ip
    network_plugin    = var.network_plugin
    service_cidr      = var.network_service_cidr
    load_balancer_sku = "standard"
  }


}

