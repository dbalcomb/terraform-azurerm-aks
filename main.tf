locals {
  tags = merge({
    "environment" = "production"
    "provisioner" = "terraform"
  }, var.tags)
}

# SERVICE PRINCIPAL

module "service_principal" {
  source = "./modules/service-principal"
  name   = local.cluster.name

  role_assignments = {
    network = {
      scope = module.network.resource_group.id
      role  = "Network Contributor"
    }
    registry = var.registry == null ? null : {
      scope = var.registry.id
      role  = "AcrPull"
    }
  }
}

# SUFFIX

locals {
  prefix = try(var.cluster.dns_prefix, var.network.dns_prefix, var.cluster.name, var.name)
}

module "suffix" {
  source = "./modules/cluster/suffix"
  input  = local.prefix
}

# MONITOR

locals {
  monitor = {
    name      = try(var.monitor.name, format("%s-monitor-%s", var.name, module.suffix.output))
    location  = var.location
    retention = try(var.monitor.retention, 30)
    enabled   = try(var.monitor.enabled, true)
    tags      = merge({ component = "monitor" }, local.tags)
  }
}

module "monitor" {
  source    = "./modules/monitor"
  name      = local.monitor.name
  location  = local.monitor.location
  retention = local.monitor.retention
  enabled   = local.monitor.enabled
  tags      = local.monitor.tags
}

# NETWORK

locals {
  network = {
    name       = try(var.network.name, format("%s-network-%s", var.name, module.suffix.output))
    location   = var.location
    dns_prefix = try(var.network.dns_prefix, var.cluster.dns_prefix, var.cluster.name, var.name)
    subnets    = try(var.network.subnets, [{ name = "primary" }])
    tags       = merge({ component = "network" }, local.tags)
  }
}

module "network" {
  source     = "./modules/network"
  name       = local.network.name
  location   = local.network.location
  dns_prefix = local.network.dns_prefix
  tags       = local.network.tags

  subnets = [
    for subnet in local.network.subnets : {
      name = subnet.name
      bits = try(subnet.bits, 8)
    }
  ]
}

# ROLE-BASED ACCESS CONTROL (RBAC)

module "administrators" {
  source  = "./modules/group"
  label   = "Azure Kubernetes Service Administrators"
  members = try(var.rbac.administrators, [])
}

locals {
  rbac = {
    administrators = try(var.rbac.administrators, [])
    admin_groups   = { (module.administrators.id) : module.administrators }
  }
}

# CLUSTER

locals {
  cluster = {
    name                     = try(var.cluster.name, format("%s-cluster-%s", var.name, module.suffix.output))
    location                 = var.location
    node_resource_group_name = try(var.cluster.node_resource_group_name, format("%s-nodepool-%s-rg", var.name, module.suffix.output))
    dns_prefix               = try(var.cluster.dns_prefix, var.network.dns_prefix, var.cluster.name, var.name)
    kubernetes_version       = try(var.cluster.kubernetes_version, null)
    pools                    = try(var.cluster.pools, { primary = {} })
    authorized_ip_ranges     = try(var.cluster.authorized_ip_ranges, [])
    tags                     = merge({ component = "cluster" }, local.tags)
  }
}

module "cluster" {
  source                   = "./modules/cluster"
  name                     = local.cluster.name
  location                 = local.cluster.location
  monitor                  = module.monitor
  network                  = module.network
  service_principal        = module.service_principal
  rbac                     = local.rbac
  dns_prefix               = local.cluster.dns_prefix
  kubernetes_version       = local.cluster.kubernetes_version
  node_resource_group_name = local.cluster.node_resource_group_name
  pools                    = local.cluster.pools
  authorized_ip_ranges     = local.cluster.authorized_ip_ranges
  tags                     = local.cluster.tags
  debug                    = var.debug
}
