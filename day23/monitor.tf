

resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "exampleact"

  email_receiver {
    name          = "sendtoadmin"
    email_address = "pranav592003@gmail.com"
  }

  depends_on = [azurerm_linux_virtual_machine.example]
}

resource "azurerm_monitor_metric_alert" "example1" {
  name                = "example-metricalert-1"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_linux_virtual_machine.example.id]
  description         = "Action will be triggered when CPU is greater than 60."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}





resource "azurerm_monitor_metric_alert" "example2" {
  name                = "example-metricalert-2"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_linux_virtual_machine.example.id]
  description         = "Action will be triggered when available memory space is lesser than 20."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 20
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
