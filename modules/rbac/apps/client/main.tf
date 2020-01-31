locals {
  map    = var.server.scopes == null ? {} : var.server.scopes
  scopes = { for item in local.map : item.value => item.id }
}

resource "azuread_application" "main" {
  count         = var.enabled ? 1 : 0
  name          = var.name
  type          = "native"
  reply_urls    = [format("https://%s", var.name)]
  public_client = true

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
