output "id" {
  description = "The application identifier"
  value       = try(azuread_application.main.0.id, null)
}

output "scopes" {
  description = "The OAuth 2.0 permission scopes"
  value       = try(azuread_application.main.0.oauth2_permissions, null)
}

output "secret" {
  description = "The client secret / application password"
  value       = try(azuread_service_principal_password.secret.0.value, null)
  sensitive   = true
}

output "service_principal" {
  description = "The service principal"
  value       = try(azuread_service_principal.main.0, null)
}
