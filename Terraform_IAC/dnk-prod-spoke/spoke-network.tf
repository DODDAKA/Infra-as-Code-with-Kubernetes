
data "azurerm_virtual_network" "vnet-cus-hub" {
  name                = "vnet-cus-hub"
  resource_group_name = "rg-dnk-hub-cus"
}
resource "azurerm_virtual_network" "vnet_name" {
  name                = var.vnet_name
  address_space       = var.vnet_address-space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ddos_protection_plan {
    enable = true
    id = azurerm_network_ddos_protection_plan.vnet_ddos_plan.id
  }
}

resource "azurerm_subnet" "snet_1" {
  name                 = var.snet_1_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_1_address_space
}

resource "azurerm_subnet" "snet_2" {
  name                 = var.snet_2_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_2_address_space
 
  service_endpoints = [
    "Microsoft.Storage",
  ]

  delegation {
    name = "delegation-postgresql-flexserver"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "snet_3" {
  name                 = var.snet_3_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_3_address_space
}


resource "azurerm_subnet" "snet_4" {
  name                 = var.snet_4_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_4_address_space
}

resource "azurerm_subnet" "snet_5" {
  name                 = var.snet_5_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_5_address_space
}

resource "azurerm_subnet" "snet_6" {
  name                 = var.snet_6_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = var.snet_6_address_space
}

resource "azurerm_virtual_network_peering" "sub1_sub2" {
  provider = azurerm.sub_hub
  name = var.sub1_to_sub2_name
  virtual_network_name = data.azurerm_virtual_network.vnet-cus-hub.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_name.id
  resource_group_name = "rg-dnk-hub-cus"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = true
}


resource "azurerm_virtual_network_peering" "sub2_sub1" {
  
  name = var.sub2_to_sub1_name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet-cus-hub.id
  resource_group_name = azurerm_resource_group.rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  
}

resource "azurerm_network_ddos_protection_plan" "vnet_ddos_plan" {
  name                = var.vnet_ddos_plan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}