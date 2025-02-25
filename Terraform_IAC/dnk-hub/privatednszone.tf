
# resource "azurerm_private_dns_zone" "stprivatednszoneblob" {
#   name                = "privatelink.blob.core.windows.net"
#   resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "vnetlinktost" {
#   name                  = "vnetlinktost"
#   resource_group_name   = azurerm_resource_group.rg-dnk-hub-cus.name
#   private_dns_zone_name = azurerm_private_dns_zone.stprivatednszoneblob.name
#   virtual_network_id    = azurerm_virtual_network.vnet-cus-hub.id
# }

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.centralus.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
}

