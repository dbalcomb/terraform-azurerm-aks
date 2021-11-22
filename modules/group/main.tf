data "azuread_user" "main" {
  for_each            = zipmap(var.members, var.members)
  user_principal_name = each.value
}

locals {
  members = {
    for member in var.members : member => {
      id    = data.azuread_user.main[member].id
      label = data.azuread_user.main[member].display_name
      email = data.azuread_user.main[member].user_principal_name
    }
  }
}

resource "azuread_group" "main" {
  display_name     = var.label
  security_enabled = true
}

resource "azuread_group_member" "main" {
  for_each         = local.members
  group_object_id  = azuread_group.main.id
  member_object_id = each.value.id
}
