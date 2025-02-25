

data "terraform_remote_state" "remote-hub-state-file" {
backend = "azurerm"

config = {
    resource_group_name  = "rg-dnk-hub-tf-cus-001" # Resource group where the Storage Account is located
    storage_account_name = "sacushubtfstate"    # Your Storage Account name
    container_name       = "tfstate"               # The container name where the state file will be stored
    key                  = "hub.terraform.tfstate" # The name of the state file
}

}


data "azurerm_resource_group" "rg-dnk-hub-cus" {
  name = "rg-dnk-hub-cus"
  provider = azurerm.sub_hub
}

data "azurerm_private_dns_zone" "aks" {
  name = "privatelink.centralus.azmk8s.io"
  resource_group_name = "rg-dnk-hub-cus"
  provider = azurerm.sub_hub
}