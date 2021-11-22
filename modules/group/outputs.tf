output "id" {
  description = "The group identifier"
  value       = azuread_group.main.id
}

output "label" {
  description = "The group label"
  value       = azuread_group.main.display_name
}

output "members" {
  description = "The group members"
  value       = local.members
}
