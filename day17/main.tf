resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "canadacentral"
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}


resource "azurerm_linux_web_app" "as" {
  name                = "${var.prefix}-webapppranav"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}


resource "azurerm_linux_web_app_slot" "slot1" {
  name           = "${var.prefix}-slot1"
  app_service_id = azurerm_linux_web_app.as.id
  site_config {}
}
