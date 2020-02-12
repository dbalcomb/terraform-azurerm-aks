output "name" {
  description = "The controller name"
  value       = try(helm_release.main.0.name, null)
}

output "namespace" {
  description = "The controller namespace"
  value       = try(helm_release.main.0.namespace, null)
}
