output "rg-name" {
  value = local.formatted_name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "network_security_group" {
  value = azurerm_network_security_group.example.name
}