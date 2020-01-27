terraform {
  required_providers {
    azuread = ">= 0.7"
    null    = ">= 2.1"
    random  = ">= 2.2"
  }
}

data "azuread_service_principal" "graph" {
  display_name = "Microsoft Graph"
}

locals {
  roles  = { for item in data.azuread_service_principal.graph.app_roles : item.value => item.id }
  scopes = { for item in data.azuread_service_principal.graph.oauth2_permissions : item.value => item.id }
}

resource "azuread_application" "main" {
  name                    = var.name
  type                    = "webapp/api"
  identifier_uris         = [format("https://%s", var.name)]
  group_membership_claims = "All"

  required_resource_access {
    resource_app_id = data.azuread_service_principal.graph.application_id

    resource_access {
      id   = lookup(local.roles, "Directory.Read.All")
      type = "Role"
    }

    resource_access {
      id   = lookup(local.scopes, "Directory.Read.All")
      type = "Scope"
    }

    resource_access {
      id   = lookup(local.scopes, "User.Read")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "random_password" "secret" {
  length = 48

  keepers = {
    id = azuread_service_principal.main.id
  }
}

resource "azuread_service_principal_password" "secret" {
  service_principal_id = azuread_service_principal.main.id
  value                = random_password.secret.result
  end_date             = "2299-12-31T00:00:00Z"
}

resource "null_resource" "consent" {
  count = var.consent == true ? 1 : 0

  provisioner "local-exec" {
    command = format("az ad app permission admin-consent --id %s", azuread_application.main.application_id)
  }
}
