resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
  tags     = var.tags
}

locals {
  pools = {
    for name, pool in var.pools : name => {
      subnet    = try(pool.subnet, "primary")
      size      = try(pool.size, "Standard_D2s_v3")
      pod_limit = try(pool.pod_limit, 250)
      disk_size = try(pool.disk_size, 30)

      scale = {
        min = try(pool.scale.min, max(min(split("-", pool.scale)...), 1), 1)
        max = try(pool.scale.max, min(max(split("-", pool.scale)...), 100), 1)
      }
    }
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                            = format("%s-aks", var.name)
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  node_resource_group             = var.node_resource_group_name
  dns_prefix                      = var.dns_prefix
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.authorized_ip_ranges
  tags                            = var.tags

  default_node_pool {
    name                = "nodepool"
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.network.subnets.primary.id
    vm_size             = local.pools.primary.size
    node_count          = local.pools.primary.scale.min
    enable_auto_scaling = local.pools.primary.scale.min == local.pools.primary.scale.max ? false : true
    min_count           = local.pools.primary.scale.min == local.pools.primary.scale.max ? null : local.pools.primary.scale.min
    max_count           = local.pools.primary.scale.min == local.pools.primary.scale.max ? null : local.pools.primary.scale.max
    max_pods            = local.pools.primary.pod_limit
    os_disk_size_gb     = local.pools.primary.disk_size
  }

  service_principal {
    client_id     = var.service_principal.application_id
    client_secret = var.service_principal.secret
  }

  role_based_access_control {
    enabled = local.rbac.enabled

    dynamic "azure_active_directory" {
      for_each = local.rbac.enabled ? [1] : []

      content {
        client_app_id     = try(var.rbac.client.id, null)
        server_app_id     = try(var.rbac.server.id, null)
        server_app_secret = try(var.rbac.server.secret, null)
      }
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

    kube_dashboard {
      enabled = local.dashboard.enabled
    }

    oms_agent {
      enabled                    = local.monitor.enabled
      log_analytics_workspace_id = try(var.monitor.log_analytics_workspace.id, null)
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count
    ]
  }
}

locals {
  addon_pools = {
    for name, pool in local.pools : name => pool
    if name != "primary"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each              = local.addon_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vnet_subnet_id        = var.network.subnets[each.value.subnet].id
  vm_size               = each.value.size
  node_count            = each.value.scale.min
  enable_auto_scaling   = each.value.scale.min == each.value.scale.max ? false : true
  min_count             = each.value.scale.min == each.value.scale.max ? null : each.value.scale.min
  max_count             = each.value.scale.min == each.value.scale.max ? null : each.value.scale.max
  max_pods              = each.value.pod_limit
  os_disk_size_gb       = each.value.disk_size
  os_type               = "Linux"
  tags                  = var.tags

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

resource "local_file" "kubeconfig" {
  filename          = "${path.cwd}/kubeconfig"
  file_permission   = "0644"
  sensitive_content = local.rbac.enabled ? azurerm_kubernetes_cluster.main.kube_admin_config_raw : azurerm_kubernetes_cluster.main.kube_config_raw
}

locals {
  dashboard = {
    name    = format("%s-dashboard", var.name)
    enabled = try(var.dashboard.enabled, true)
  }
}

module "dashboard" {
  source  = "./dashboard"
  name    = local.dashboard.name
  enabled = local.dashboard.enabled
}

locals {
  monitor = {
    name    = format("%s-monitor", var.name)
    enabled = try(var.monitor.enabled, true)
  }
}

module "monitor" {
  source            = "./monitor"
  name              = format("%s-monitor", var.name)
  cluster           = azurerm_kubernetes_cluster.main
  monitor           = var.monitor
  service_principal = var.service_principal
  enabled           = local.monitor.enabled
  debug             = var.debug
}

# Note: Terraform has trouble understanding that the group keys, when used via
# try and lookup functions, are already known before the apply stage. We must
# therefore use the group configuration, which does not have this problem, and
# remap the values.
#
# Todo: Remove the following locals when the above limitation is fixed or when
# the ability to provide optional nested values is added.
#
# See:
# https://github.com/hashicorp/terraform/issues/19898

locals {
  groups_conf = try(var.rbac.groups.config, {})
  groups_list = try(var.rbac.groups.groups, {})
  groups = {
    for key in keys(local.groups_conf) : key => local.groups_list[key]
  }
}

locals {
  rbac = {
    name    = format("%s-rbac", var.name)
    enabled = try(var.rbac.enabled, true)
  }
}

module "rbac" {
  source  = "./rbac"
  name    = local.rbac.name
  groups  = local.groups
  cluster = azurerm_kubernetes_cluster.main
  enabled = local.rbac.enabled
}

locals {
  kured = {
    name    = format("%s-kured", var.name)
    enabled = try(var.kured.enabled, true)
  }
}

module "kured" {
  source  = "./kured"
  name    = local.kured.name
  enabled = local.kured.enabled
}
