data "azuread_service_principal" "aad" {
  count        = var.enabled ? 1 : 0
  display_name = "Windows Azure Active Directory"
}

locals {
  aad_scopes = try(data.azuread_service_principal.aad.0.oauth2_permission_scope_ids, {})
}

locals {
  server_scopes = var.server.scopes == null ? {} : var.server.scopes
}

resource "azuread_application" "main" {
  count                          = var.enabled ? 1 : 0
  display_name                   = var.name
  fallback_public_client_enabled = true

  web {
    redirect_uris = []

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  public_client {
    redirect_uris = [
      "https://${var.name}",
      "https://login.microsoftonline.com/common/oauth2/nativeclient",
      "https://afd.hosting.portal.azure.net/monitoring/Content/iframe/infrainsights.app/web/base-libs/auth/auth.html",
      "https://monitoring.hosting.portal.azure.net/monitoring/Content/iframe/infrainsights.app/web/base-libs/auth/auth.html",
    ]
  }

  required_resource_access {
    resource_app_id = data.azuread_service_principal.aad.0.application_id

    resource_access {
      id   = lookup(local.aad_scopes, "User.Read")
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = var.server.id

    resource_access {
      id   = lookup(local.server_scopes, "user_impersonation")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "main" {
  count          = var.enabled ? 1 : 0
  application_id = azuread_application.main.0.application_id
}
