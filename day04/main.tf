terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>4.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "backend-rg"
    storage_account_name = "backendstoracc15794"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
    
  }

  required_version = ">=1.9.0"
}


provider "azurerm" {
  features {
    
  }
}


resource "azurerm_resource_group" "example" {
  name = "pranav-rg"
  location = "north europe"
}

resource "azurerm_storage_account" "example" {
  name = "techtutorialspranav"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  account_tier = "Standard"
  account_replication_type = "LRS"

  tags = { 
        environment = "staging" 
    }
}
