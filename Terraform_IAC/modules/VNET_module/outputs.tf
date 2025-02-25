output "vnet_id" {
   value = azurerm_virtual_network.vnetmodule.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnetmodule.name
}

output "vnet_resource_group_name" {
  value = azurerm_virtual_network.vnetmodule.resource_group_name
}

output "vnet_address_space" {
  value = azurerm_virtual_network.vnetmodule.address_space
}

output "vnet_location" {
  value = azurerm_virtual_network.vnetmodule.location
}

output "snet_id" {
  value = { for k,v in azurerm_subnet.sntmodule: k=> v.id }
}

output "snet_name" {
  value = { for k,v in azurerm_subnet.sntmodule: k=> v.name }
}

output "snet_address_prefixes" {
  value = { for k,v in azurerm_subnet.sntmodule: k=> v.address_prefixes }
}