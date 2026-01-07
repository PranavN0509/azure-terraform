terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.8.0"
    }
  }

  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {
    
  }
}


# Variables passed with the terraform plan command have highest precedence followed by the variables in terraform.tfvars and then the input variabes defined in main.tf file itself

# input variable
variable "environment" {
  type        = string
  default     = "staging"
  description = "This is the environment varibale"
}


# local variables
locals {
  common_tags = {
    environment = "dev"
    lob = "banking"
    stage = "alpha"
  }
}



resource "azurerm_storage_account" "example" {
  name = "techtutorialspranav"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  account_tier = "Standard"
  account_replication_type = "LRS"

  tags = { 
        environment = var.environment 
    }
}



# output variables

output "storage_account_name" {
    value = azurerm_storage_account.example.name
}
