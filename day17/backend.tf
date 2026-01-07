terraform {
    backend "azurerm" {
    resource_group_name = "backend-rg"
    storage_account_name = "backendstoracc46094"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
    
  }
}