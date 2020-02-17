data "azuread_service_principal" "aad" {
  count        = var.enabled ? 1 : 0
  display_name = "Windows Azure Active Directory"
}

locals {
  aad_scopes = { for item in try(data.azuread_service_principal.aad.0.oauth2_permissions, []) : item.value => item.id }
}

locals {
  map    = var.server.scopes == null ? {} : var.server.scopes
  scopes = { for item in local.map : item.value => item.id }
}

resource "azuread_application" "main" {
  count         = var.enabled ? 1 : 0
  name          = var.name
  type          = "native"
  public_client = true

  reply_urls = [
    "https://${var.name}",
    "https://login.microsoftonline.com/common/oauth2/nativeclient",
    "https://afd.hosting.portal.azure.net/monitoring/Content/iframe/infrainsights.app/web/base-libs/auth/auth.html",
    "https://monitoring.hosting.portal.azure.net/monitoring/Content/iframe/infrainsights.app/web/base-libs/auth/auth.html",
  ]

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
      id   = lookup(local.scopes, "user_impersonation")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "main" {
  count          = var.enabled ? 1 : 0
  application_id = azuread_application.main.0.application_id
}
