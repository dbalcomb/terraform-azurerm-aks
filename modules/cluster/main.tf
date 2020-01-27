locals {
  pools = {
    for name, pool in var.pools : name => pool
    if name != "primary"
  }
}

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
    name            = "primary"
    type            = "VirtualMachineScaleSets"
    vnet_subnet_id  = var.network.subnets.primary.id
    vm_size         = var.pools.primary.size
    node_count      = var.pools.primary.scale
    max_pods        = var.pools.primary.pod_limit
    os_disk_size_gb = var.pools.primary.disk_size
  }

  service_principal {
    client_id     = var.service_principal.id
    client_secret = var.service_principal.secret
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
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

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each              = local.pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = var.network.subnets[each.value.subnet].id
  vm_size               = each.value.size
  node_count            = each.value.scale
  max_pods              = each.value.pod_limit
  os_disk_size_gb       = each.value.disk_size
  os_type               = "Linux"
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
