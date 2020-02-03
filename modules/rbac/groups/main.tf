locals {
  groups = {
    for key, group in var.config : key => {
      label   = group.label
      members = group.members
    }
    if group.enabled
  }
}

resource "azuread_group" "main" {
  for_each = local.groups
  name     = each.value.label
}

locals {
  user_list = distinct(flatten([
    for group in local.groups : group.members
  ]))
  users = zipmap(local.user_list, local.user_list)
}

data "azuread_user" "main" {
  for_each            = local.users
  user_principal_name = each.value
}

locals {
  member_list = flatten([
    for key, group in local.groups : [
      for member in group.members : {
        key   = format("%s::%s", key, member)
        user  = data.azuread_user.main[member]
        group = azuread_group.main[key]
      }
    ]
  ])
  members = {
    for item in local.member_list : item.key => {
      user  = item.user
      group = item.group
    }
  }
}

resource "azuread_group_member" "main" {
  for_each         = local.members
  group_object_id  = each.value.group.id
  member_object_id = each.value.user.id
}
