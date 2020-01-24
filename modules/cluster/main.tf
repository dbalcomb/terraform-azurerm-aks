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
    name           = "node"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.network.subnet.id
  }

  service_principal {
    client_id     = var.service_principal.id
    client_secret = var.service_principal.secret
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = var.network.dns_service_ip
    service_cidr       = var.network.service_cidr
    docker_bridge_cidr = var.network.docker_bridge_cidr
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.monitor.log_analytics_workspace.id
    }
  }
}

resource "azurerm_role_assignment" "network" {
  principal_id         = var.service_principal.id
  scope                = var.network.resource_group.id
  role_definition_name = "Network Contributor"
}

resource "azurerm_role_assignment" "metrics" {
  principal_id         = var.service_principal.id
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
}
