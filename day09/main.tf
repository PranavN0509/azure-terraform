resource "azurerm_resource_group" "example" {


  lifecycle {
    create_before_destroy = true
  }

  name     = "${var.environment}-resources"
  location = var.allowed_locations[1]
  tags = { 
    "environment" = var.environment 
    }
}



# using count for creating multiple resources of same type
# resource "azurerm_storage_account" "example" {
#   name                     = var.storage_account_name[count.index]
#   # count                    = 2    # specifies the number of the resources to be created
#   count                    = length(var.storage_account_name)   # specifies the number of the resources to be created
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "staging"
#   }
# }


# using for each for creating multiple resources of same type
resource "azurerm_storage_account" "example" {

  lifecycle {
    # create_before_destroy = true
    # ignore_changes = [ tags ]
    # prevent_destroy = true
    replace_triggered_by = [ azurerm_resource_group.example ]
    precondition {
      condition = contains(var.allowed_locations, "West Europe")
      error_message = "The location West Europe is not in allowed_locations"
    }
  }

  for_each                 = var.storage_account_name  # specifies the number of the resources to be created
  name                     = each.value
  # count                    = 2    # specifies the number of the resources to be created
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Premium"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}
