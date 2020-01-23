resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg", var.name)
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  node_resource_group = format("%s-node-rg", var.name)
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "node"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.service_principal.id
    client_secret = var.service_principal.secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics.workspace.id
    }
  }
}
