data "azuread_service_principal" "aad" {
  count        = var.enabled ? 1 : 0
  display_name = "Windows Azure Active Directory"
}

locals {
  aad_scopes = try(data.azuread_service_principal.aad.0.oauth2_permission_scope_ids, {})
}

data "azuread_service_principal" "graph" {
  count        = var.enabled ? 1 : 0
  display_name = "Microsoft Graph"
}

locals {
  graph_roles  = try(data.azuread_service_principal.graph.0.app_role_ids, {})
  graph_scopes = try(data.azuread_service_principal.graph.0.oauth2_permission_scope_ids, {})
}

resource "random_uuid" "user_impersonation_scope" {}

resource "azuread_application" "main" {
  count                   = var.enabled ? 1 : 0
  display_name            = var.name
  identifier_uris         = [format("https://%s", var.name)]
  group_membership_claims = ["All"]

  api {
    oauth2_permission_scope {
      admin_consent_description  = format("Allow the application to access %s on behalf of the signed-in user.", var.name)
      admin_consent_display_name = format("Access %s", var.name)
      id                         = random_uuid.user_impersonation_scope.result
      enabled                    = true
      type                       = "User"
      user_consent_description   = format("Allow the application to access %s on your behalf.", var.name)
      user_consent_display_name  = format("Access %s", var.name)
      value                      = "user_impersonation"
    }
  }

  web {
    homepage_url  = format("https://%s", var.name)
    redirect_uris = []

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

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

resource "azuread_service_principal_password" "secret" {
  count                = var.enabled ? 1 : 0
  service_principal_id = azuread_service_principal.main.0.id
}

resource "null_resource" "consent" {
  count = var.enabled && var.consent == true ? 1 : 0

  provisioner "local-exec" {
    command = format("az ad app permission admin-consent --id %s", azuread_application.main.0.application_id)
  }
}
