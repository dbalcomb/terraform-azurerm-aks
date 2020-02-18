output "id" {
  description = "The application identifier"
  value       = try(azuread_application.main.0.application_id, null)
}

output "service_principal" {
  description = "The service principal"
  value       = try(azuread_service_principal.main.0, null)
}
