output "log_analytics_workspace" {
  description = "The Log Analytics Workspace"
  value       = try(azurerm_log_analytics_workspace.main.0, null)
}

output "enabled" {
  description = "Monitoring is enabled"
  value       = var.enabled
}
