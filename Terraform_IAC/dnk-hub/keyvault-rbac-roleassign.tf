# data "azurerm_subscription" "primary" {
# }

# data "azurerm_client_config" "example" {
# }
# ### ChatGPT
# resource "azurerm_role_assignment" "kv_admin_role" {
#   principal_id   = azuread_service_principal.example.object_id # Replace with the target principal's ID
#   role_definition_name = "Key Vault Administrator" # Use "Key Vault Reader" or other roles as needed
#   scope          = azurerm_key_vault.kv-dnk-hub-cus.id
# }

### ChatGPT
# data "azuread_user" "user" {
#   user_principal_name = "Naveen.m@msritserv.onmicrosoft.com"
# }

# resource "azurerm_role_assignment" "kv_admin_role" {
#   principal_id         = data.azuread_user.user.id # Replace with the user ID
#   role_definition_name = "Key Vault Administrator"
#   scope                = azurerm_key_vault.kv-dnk-hub-cus.id
# }


# #### 
# data "azurerm_subscription" "primary" {
# }


############################################################# RBAC ##################3
data "azurerm_client_config" "example" {
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_key_vault.kv-dnk-hub-cus.id
  role_definition_name = "Key Vault Administrator"
  principal_id         =  "7b0317d1-a499-4812-8f06-d975294d7d51"
}
#"7b0317d1-a499-4812-8f06-d975294d7d51"