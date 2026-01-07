output "rg-name" {
  value = local.formatted_name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "network_security_group" {
  value = azurerm_network_security_group.example.name
}

output "vm_size" {
  value = local.vm_size
}

output "backup" {
  value = var.backup_name
}

output "backup-credential" {
  value     = var.backup_credential
  sensitive = true
}


output "unique_locations" {
  value = local.unique_locations
}

output "max_cost" {
  value = local.max_cost
}

output "positive_cost" {
  value = local.positive_costs
}

output "config_loaded" {
  value = nonsensitive(jsondecode(local.config_content))
}
