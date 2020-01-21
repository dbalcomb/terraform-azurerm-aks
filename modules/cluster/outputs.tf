output "kubernetes" {
  description = "The Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0
}
