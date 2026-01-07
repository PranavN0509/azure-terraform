terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "example" {
  name     = "pranav-rg"
  location = "north europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "pranavstoragedemoacc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

