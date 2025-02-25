 #####################################################
 ################# RUN this file after key vault creation and create certificate pkcs(pfx) format ############
 #####################################################
 
 



 resource "azurerm_public_ip" "app-gw-pip" {
  name                = var.app-gw-pip
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  allocation_method   = "Static"
}

locals {
  backend_address_pool_name      = "${module.vnet.vnet_name}-beap"
  frontend_port_name             = "${module.vnet.vnet_name}-feport"
  frontend_ip_configuration_name = "${module.vnet.vnet_name}-feip"
  http_setting_name              = "${module.vnet.vnet_name}-be-htst"
  listener_name                  = "${module.vnet.vnet_name}-httplstn"
  request_routing_rule_name      = "${module.vnet.vnet_name}-rqrt"
  redirect_configuration_name    = "${module.vnet.vnet_name}-rdrcfg"
}

resource "azurerm_application_gateway" "app-gw" {
  name                = var.app-gw
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  location            = azurerm_resource_group.rg-dnk-hub-cus.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = module.vnet.snet_id[var.snet-hub-appgw-01-cus]
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.useridentityforkv.id]
  }
  ################# choose certificate pfx
  ssl_certificate {
    name= azurerm_key_vault_certificate.example2.name
    key_vault_secret_id = azurerm_key_vault_certificate.example2.secret_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_port {
    name="fp_dnk"
    port = 80
  }
  

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app-gw-pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_address_pool {
    name = "bp_dnk"
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name = "backend_settings_dnk"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name = azurerm_key_vault_certificate.example2.name
    
  }

  http_listener {
    name = "http_listener_dnk"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    protocol = "Http"
    frontend_port_name = "fp_dnk"
  }
    
    
  
  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  request_routing_rule {
    name = "rr_dnk"
    priority = 10
    rule_type = "Basic"
    http_listener_name = "http_listener_dnk"
    backend_address_pool_name = "bp_dnk"
    backend_http_settings_name = "backend_settings_dnk"
  }
}
