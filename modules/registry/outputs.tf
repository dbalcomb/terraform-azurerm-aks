output "id" {
  description = "The container registry resource identifier"
  value       = azurerm_container_registry.main.id
}

output "url" {
  description = "The registry URL"
  value       = azurerm_container_registry.main.login_server
}

output "username" {
  description = "The admin username"
  value       = azurerm_container_registry.main.admin_username
}

output "password" {
  description = "The admin password"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "resource_group" {
  description = "The resource group"
  value       = azurerm_resource_group.main
}
