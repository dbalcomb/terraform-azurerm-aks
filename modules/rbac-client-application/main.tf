locals {
  scopes = { for item in var.server.scopes : item.value => item.id }
}

resource "azuread_application" "main" {
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
  application_id = azuread_application.main.application_id
}
