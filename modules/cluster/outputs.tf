output "kubernetes" {
  description = "The Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.main.kube_config.0
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
