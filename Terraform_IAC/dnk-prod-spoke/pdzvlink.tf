


resource "azurerm_private_dns_zone_virtual_network_link" "pdzvlink-xclient-aks" {
  provider = azurerm.sub_hub
  name                  = "pdzvlink-xclient-aks"
  resource_group_name   = data.azurerm_resource_group.rg-dnk-hub-cus.name
  private_dns_zone_name = data.azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.vnet_name.id
}