output "server" {
  description = "The server application registration"
  value       = module.server
}

output "client" {
  description = "The client application registration"
  value       = module.client
}

output "groups" {
  description = "The group information"
  value       = module.groups
}

output "enabled" {
  description = "Role-based access control is enabled"
  value       = var.enabled
}
