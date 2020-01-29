resource "azurerm_role_assignment" "registry" {
  principal_id         = var.service_principal.id
  scope                = var.registry.resource_group.id
  role_definition_name = "AcrPull"
}
