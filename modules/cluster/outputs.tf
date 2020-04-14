output "id" {
  description = "The cluster identifier"
  value       = azurerm_kubernetes_cluster.main.id
}

output "name" {
  description = "The cluster name"
  value       = azurerm_kubernetes_cluster.main.name
}

output "group" {
  description = "The cluster group"
  value       = azurerm_kubernetes_cluster.main.resource_group_name
}

output "region" {
  description = "The cluster region"
  value       = azurerm_kubernetes_cluster.main.location
}

output "kubernetes" {
  description = "The Kubernetes configuration"
  value       = local.rbac.enabled ? azurerm_kubernetes_cluster.main.kube_admin_config.0 : azurerm_kubernetes_cluster.main.kube_config.0
}

output "ssh_public_key" {
  description = "The SSH public key"
  value       = tls_private_key.ssh.public_key_pem
  sensitive   = true
}

output "ssh_private_key" {
  description = "The SSH private key"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}
