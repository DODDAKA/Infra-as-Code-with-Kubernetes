resource "azurerm_resource_group" "rg-dnk-hub-cus" {
  name     = var.resource_group_name
  location = "centralus"
}