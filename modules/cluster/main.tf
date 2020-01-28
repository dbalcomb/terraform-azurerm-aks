locals {
  pools = {
    for name, pool in var.pools : name => pool
    if name != "primary"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.name == "aks" ? "aks" : format("%s-aks", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  node_resource_group = format("%s-node-rg", var.name)
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "primary"
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.network.subnets.primary.id
    vm_size             = var.pools.primary.size
    node_count          = var.pools.primary.scale
    enable_auto_scaling = var.pools.primary.auto_scale
    min_count           = var.pools.primary.auto_scale == true ? var.pools.primary.auto_scale_min : null
    max_count           = var.pools.primary.auto_scale == true ? var.pools.primary.auto_scale_max : null
    max_pods            = var.pools.primary.pod_limit
    os_disk_size_gb     = var.pools.primary.disk_size
  }

  service_principal {
    client_id     = var.service_principal.id
    client_secret = var.service_principal.secret
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      client_app_id     = var.rbac_client_application.id
      server_app_id     = var.rbac_server_application.id
      server_app_secret = var.rbac_server_application.secret
    }
  }

  linux_profile {
    admin_username = "aks"

    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    dns_service_ip     = var.network.dns_service_ip
    service_cidr       = var.network.service_cidr
    docker_bridge_cidr = var.network.docker_bridge_cidr

    load_balancer_profile {
      outbound_ip_address_ids = [var.network.ip.id]
    }
  }

  addon_profile {
    azure_policy {
      enabled = true
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.monitor.log_analytics_workspace.id
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each              = local.pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vnet_subnet_id        = var.network.subnets[each.value.subnet].id
  vm_size               = each.value.size
  node_count            = each.value.scale
  enable_auto_scaling   = each.value.auto_scale
  min_count             = each.value.auto_scale == true ? each.value.auto_scale_min : null
  max_count             = each.value.auto_scale == true ? each.value.auto_scale_max : null
  max_pods              = each.value.pod_limit
  os_disk_size_gb       = each.value.disk_size
  os_type               = "Linux"

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
