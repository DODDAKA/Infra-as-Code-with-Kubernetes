terraform {

    required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.12.0"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.3"
    }

  }

  backend "azurerm" {
    resource_group_name  = "rg-dnk-hub-tf-cus-001" # Resource group where the Storage Account is located
    storage_account_name = "sacushubtfstate"    # Your Storage Account name
    container_name       = "tfstate"               # The container name where the state file will be stored
    key                  = "hub.terraform.tfstate" # The name of the state file
  }
  
}

# Provider for the primary subscription where the Private DNS Zone will be created
/*provider "azurerm" {
  alias           = "sub_pt"
  subscription_id = "0ad29408-aca3-4ccf-be27-b6bef32c99de"
  features {}
}*/

# Provider for the secondary subscription where the VNets or subnets are located
provider "azurerm" {
  #   alias           = "sub_hub"
  subscription_id = "3f90d050-8436-406b-9fab-303ffaef8a42"
  features {}
}

/*provider "azurerm" {
  alias           = "sub_uat"
  subscription_id = "1683e75a-3b66-4e36-b5e0-babd74a4b536"
  features {}
}*/

/*
Application (client) ID: 9521f746-c0c4-4134-bdf0-f948a131ee70
tenant ID: 86140b50-6e23-4b67-b7fb-4e23fdd33901
Client secret value: fx_8Q~PbEmEPNH3zvb3zZxHnqdbZhVhMM52GObB-
secret ID: 806b41d2-47fc-42c5-aa71-7497934012ae
*/