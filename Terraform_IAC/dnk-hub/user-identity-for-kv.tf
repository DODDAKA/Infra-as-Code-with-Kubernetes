resource "azurerm_user_assigned_identity" "useridentityforkv" {
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  name                = "useridentityforkv"
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
}