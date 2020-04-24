output "id" {
  description = "The Service Principal ID"
  value       = azuread_service_principal.main.id
}

output "application_id" {
  description = "The App Registration ID"
  value       = azuread_service_principal.main.application_id
}

output "object_id" {
  description = "The Object ID"
  value       = azuread_service_principal.main.object_id
}

output "display_name" {
  description = "The App Registration display name"
  value       = azuread_service_principal.main.display_name
}

output "secret" {
  description = "The client secret / application password"
  value       = azuread_service_principal_password.secret.value
  sensitive   = true
}
