

module "vnet" {
  source = "../modules/VNET_module"
  virtual_network_name = var.vnet-cus-hub
  vnet_resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  vnet_address_space = ["10.14.0.0/20"]
  vnet_location = azurerm_resource_group.rg-dnk-hub-cus.location
  subnets = {
    "${var.GatewaySubnet}" = { name = var.GatewaySubnet, address_prefixes = ["10.14.0.0/24"] },
    "${var.AzureFirewallSubnet}" = { name= var.AzureFirewallSubnet, address_prefixes = ["10.14.1.0/26"] },
    "${var.snet-hub-mgmt-01-cus}" = { name= var.snet-hub-mgmt-01-cus, address_prefixes = ["10.14.1.128/25"] },
    "${var.snet-hub-appgw-01-cus}" = { name = var.snet-hub-appgw-01-cus, address_prefixes = ["10.14.2.0/24"] },
    "${var.snet-hub-acr-01-cus}" = { name = var.snet-hub-acr-01-cus, address_prefixes = ["10.14.1.64/26"] }
  }
}

# resource "azurerm_virtual_network" "vnet-cus-hub" {
#   name                = var.vnet-cus-hub
#   address_space       = ["10.14.0.0/20"]
#   location            = azurerm_resource_group.rg-dnk-hub-cus.location
#   resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
# }

# resource "azurerm_subnet" "GatewaySubnet" {
#   name                 = var.GatewaySubnet
#   resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
#   virtual_network_name = azurerm_virtual_network.vnet-cus-hub.name
#   address_prefixes     = ["10.14.0.0/24"] 
# }

# resource "azurerm_subnet" "AzureFirewallSubnet" {
#   name                 = var.AzureFirewallSubnet
#   resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
#   virtual_network_name = azurerm_virtual_network.vnet-cus-hub.name
#   address_prefixes     = ["10.14.1.0/26"] 
# }

# resource "azurerm_subnet" "snet-hub-mgmt-01-cus" {
#   name                 = var.snet-hub-mgmt-01-cus
#   resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
#   virtual_network_name = azurerm_virtual_network.vnet-cus-hub.name
#   address_prefixes     = ["10.14.1.128/25"] 
# }

# resource "azurerm_subnet" "snet-hub-appgw-01-cus" {
#   name                 = var.snet-hub-appgw-01-cus
#   resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
#   virtual_network_name = azurerm_virtual_network.vnet-cus-hub.name
#   address_prefixes     = ["10.14.2.0/24"] 
# }

# resource "azurerm_subnet" "snet-hub-acr-01-cus" {
#   name                 = var.snet-hub-acr-01-cus
#   resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
#   virtual_network_name = azurerm_virtual_network.vnet-cus-hub.name
#   address_prefixes     = ["10.14.1.64/26"]
# }

resource "azurerm_network_security_group" "nsg-hub-mgmt-cus" {
  name                = "nsg-hub-mgmt-cus"
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  resource_group_name  = azurerm_resource_group.rg-dnk-hub-cus.name
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet-hub-mgmt-01-cus" {
  #subnet_id                 = azurerm_subnet.snet-hub-mgmt-01-cus.id
  subnet_id                 = module.vnet.snet_id[var.snet-hub-mgmt-01-cus]
  network_security_group_id = azurerm_network_security_group.nsg-hub-mgmt-cus.id
}

resource "azurerm_route_table" "rt-hub-mgmt-cus" {
  name                = "rt-hub-mgmt-cus"
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

}

resource "azurerm_subnet_route_table_association" "snet-hub-mgmt-01-cus" {
  #subnet_id      = azurerm_subnet.snet-hub-mgmt-01-cus.id
   subnet_id      = module.vnet.snet_id[var.snet-hub-mgmt-01-cus]
  route_table_id = azurerm_route_table.rt-hub-mgmt-cus.id
}