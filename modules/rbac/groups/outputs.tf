output "config" {
  description = "The group configuration"
  value       = local.groups
}

output "groups" {
  description = "The group information"
  value = {
    for key, group in local.groups : key => {
      id    = azuread_group.main[key].id
      label = group.label
      members = {
        for name, member in group.members : name => {
          id    = data.azuread_user.main[member].id
          label = data.azuread_user.main[member].display_name
          email = data.azuread_user.main[member].user_principal_name
        }
      }
    }
  }
}
