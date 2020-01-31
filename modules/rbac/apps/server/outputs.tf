output "id" {
  description = "The application identifier"
  value       = azuread_application.main.id
}

output "scopes" {
  description = "The OAuth 2.0 permission scopes"
  value       = azuread_application.main.oauth2_permissions
}

output "secret" {
  description = "The client secret / application password"
  value       = azuread_service_principal_password.secret.value
  sensitive   = true
}

output "service_principal" {
  description = "The service principal"
  value       = azuread_service_principal.main
}
