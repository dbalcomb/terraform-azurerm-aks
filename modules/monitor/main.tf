resource "azurerm_resource_group" "main" {
  count    = var.enabled ? 1 : 0
  name     = format("%s-rg", var.name)
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = var.enabled ? 1 : 0
  name                = format("%s-la", var.name)
  resource_group_name = azurerm_resource_group.main.0.name
  location            = azurerm_resource_group.main.0.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "container_insights" {
  count                 = var.enabled ? 1 : 0
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.main.0.name
  location              = azurerm_log_analytics_workspace.main.0.location
  workspace_resource_id = azurerm_log_analytics_workspace.main.0.id
  workspace_name        = azurerm_log_analytics_workspace.main.0.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
