terraform {
    backend "azurerm" {
    resource_group_name = "backend-rg"
    storage_account_name = "backendstoracc41876"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
    
  }
}