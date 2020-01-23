terraform {
  required_providers {
    azurerm = ">= 1.41"
  }
}

resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_log_analytics_workspace.main.location
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
