resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
}

resource "azurerm_container_registry" "main" {
  name                = var.dns_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.sku
  admin_enabled       = true
}

resource "azurerm_role_assignment" "main" {
  principal_id         = var.service_principal.id
  scope                = azurerm_resource_group.main.id
  role_definition_name = "AcrPull"
}
