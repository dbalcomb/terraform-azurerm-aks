resource "azuread_application" "main" {
  name                       = var.name
  type                       = "webapp/api"
  available_to_other_tenants = false
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

resource "azurerm_role_assignment" "main" {
  for_each             = var.role_assignments
  principal_id         = azuread_service_principal.main.id
  scope                = each.value.scope
  role_definition_name = each.value.role
}
