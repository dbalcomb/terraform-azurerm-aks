output "kubernetes" {
  description = "The Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.main.kube_config.0
}
