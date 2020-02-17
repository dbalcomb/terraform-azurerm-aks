data "azuread_service_principal" "aad" {
  count        = var.enabled ? 1 : 0
  display_name = "Windows Azure Active Directory"
}

locals {
  aad_scopes = { for item in try(data.azuread_service_principal.aad.0.oauth2_permissions, []) : item.value => item.id }
}

data "azuread_service_principal" "graph" {
  count        = var.enabled ? 1 : 0
  display_name = "Microsoft Graph"
}

locals {
  graph_roles  = { for item in try(data.azuread_service_principal.graph.0.app_roles, []) : item.value => item.id }
  graph_scopes = { for item in try(data.azuread_service_principal.graph.0.oauth2_permissions, []) : item.value => item.id }
}

resource "azuread_application" "main" {
  count                   = var.enabled ? 1 : 0
  name                    = var.name
  type                    = "webapp/api"
  identifier_uris         = [format("https://%s", var.name)]
  group_membership_claims = "All"

  required_resource_access {
    resource_app_id = data.azuread_service_principal.aad.0.application_id

    resource_access {
      id   = lookup(local.aad_scopes, "User.Read")
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_service_principal.graph.0.application_id

    resource_access {
      id   = lookup(local.graph_roles, "Directory.Read.All")
      type = "Role"
    }

    resource_access {
      id   = lookup(local.graph_scopes, "Directory.Read.All")
      type = "Scope"
    }

    resource_access {
      id   = lookup(local.graph_scopes, "User.Read")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "main" {
  count          = var.enabled ? 1 : 0
  application_id = azuread_application.main.0.application_id
}

resource "random_password" "secret" {
  count  = var.enabled ? 1 : 0
  length = 48

  keepers = {
    id = azuread_service_principal.main.0.id
  }
}

resource "azuread_service_principal_password" "secret" {
  count                = var.enabled ? 1 : 0
  service_principal_id = azuread_service_principal.main.0.id
  value                = random_password.secret.0.result
  end_date             = "2299-12-31T00:00:00Z"
}

resource "null_resource" "consent" {
  count = var.enabled && var.consent == true ? 1 : 0

  provisioner "local-exec" {
    command = format("az ad app permission admin-consent --id %s", azuread_application.main.0.application_id)
  }
}
