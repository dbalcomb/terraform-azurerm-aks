output "id" {
  description = "The application identifier"
  value       = azuread_application.main.id
}

output "service_principal" {
  description = "The service principal"
  value       = azuread_service_principal.main
}
