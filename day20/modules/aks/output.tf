output "config" {
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

output "aks_ssh_private_key" {
  value     = tls_private_key.aks_ssh.private_key_pem
  sensitive = true
}