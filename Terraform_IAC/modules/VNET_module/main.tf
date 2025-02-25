resource "azurerm_virtual_network" "vnetmodule" {
  name                = var.virtual_network_name
  location            = var.vnet_location
  resource_group_name = var.vnet_resource_group_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "sntmodule" {
  for_each = var.subnets
  name                 = each.value.name
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.vnetmodule.name
  address_prefixes     = each.value.address_prefixes
}