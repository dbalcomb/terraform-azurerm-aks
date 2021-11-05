locals {
  role_assignments = {
    for key, val in var.role_assignments : key => val if val != null
  }
}

resource "random_uuid" "user_impersonation_scope" {}

resource "azuread_application" "main" {
  display_name = var.name

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
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "azuread_service_principal_password" "secret" {
  service_principal_id = azuread_service_principal.main.id
}

resource "azurerm_role_assignment" "main" {
  for_each             = local.role_assignments
  principal_id         = azuread_service_principal.main.id
  scope                = each.value.scope
  role_definition_name = each.value.role
}
