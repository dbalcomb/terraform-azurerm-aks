output "cluster" {
  description = "The Azure Kubernetes Service cluster"
  value       = module.cluster
}

output "service_principal" {
  description = "The service principal"
  value       = module.service_principal
}
