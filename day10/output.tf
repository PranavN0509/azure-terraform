output "rgname" {
  value = azurerm_resource_group.example[*].name
}


output "env" {
  value = var.environment
  
}