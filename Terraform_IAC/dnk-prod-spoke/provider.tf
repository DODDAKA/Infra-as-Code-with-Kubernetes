
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
    key                  = "cvs-spoke.terraform.tfstate" # The name of the state file
  }
  
}

# Provider for the primary subscription where the Private DNS Zone will be created
provider "azurerm" {
  #   alias = "sub_pt"
  subscription_id = "3f90d050-8436-406b-9fab-303ffaef8a42"
  features {}
}

# Provider for the secondary subscription where the VNets or subnets are located
provider "azurerm" {
  alias           = "sub_hub"
  subscription_id = "3f90d050-8436-406b-9fab-303ffaef8a42"
  features {}
}