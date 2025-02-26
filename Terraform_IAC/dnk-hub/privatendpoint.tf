

resource "azurerm_private_endpoint" "storageprivatendpoint" {
  name                = "pe-st-${azurerm_resource_group.rg-dnk-hub-cus.location}"
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  subnet_id           = azurerm_subnet.snet-hub-mgmt-01-cus.id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.test_stotage_acc.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.stprivatednszoneblob.id]
  }
}