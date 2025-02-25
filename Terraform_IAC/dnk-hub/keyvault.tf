

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv-dnk-hub-cus" {
  name                = var.kv-dnk-hub-cus
  enable_rbac_authorization       = false  ### if we enable RBAC, kv access policy won't be enabled any more.
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  network_acls {
    bypass = "AzureServices"
    default_action = "Allow"
  }
}

resource "azurerm_key_vault_access_policy" "kv-dnk-hub-cus-access-policy" {
  key_vault_id = azurerm_key_vault.kv-dnk-hub-cus.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "8a19bd41-1cda-439f-9cf0-0e9f81faedd0"
  

  key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "List"
    ]

  secret_permissions = [
    "Get", "Delete", "List"
  ]

  certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]
}


resource "azurerm_key_vault_access_policy" "kv-user-identity-access-policy" {
  key_vault_id = azurerm_key_vault.kv-dnk-hub-cus.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.useridentityforkv.principal_id  ### with Principal id able to identify the spplicstion name
  key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "List"
    ]

  secret_permissions = [
    "Get", 
    "Delete", 
    "List"
  ]

  certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]

}

resource "azurerm_key_vault_certificate" "example2" {
  name         = "imported-cert3"
  key_vault_id = azurerm_key_vault.kv-dnk-hub-cus.id
  depends_on = [ azurerm_key_vault_access_policy.kv-user-identity-access-policy,azurerm_key_vault_access_policy.kv-dnk-hub-cus-access-policy ]

  certificate {
    contents = filebase64("mppp_2024.pfx")
    password = "Naveenncx.n@321"
  }
}