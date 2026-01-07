resource "azurerm_resource_group" "example" {
  name     = "${local.formatted_name}-rg"
  location = "West Europe"

  tags = local.merge_tags
}



resource "azurerm_storage_account" "example" {
  name                     = local.storage_account_name_formatted
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Premium"
  account_replication_type = "LRS"

  tags = local.merge_tags
}


resource "azurerm_network_security_group" "example" {
  name                = "${local.formatted_name}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}