resource "azurerm_role_assignment" "network" {
  principal_id         = var.service_principal.id
  scope                = var.network.resource_group.id
  role_definition_name = "Network Contributor"
}
