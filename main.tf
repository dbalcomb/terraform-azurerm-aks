provider "kubernetes" {
  host                   = module.cluster.kubernetes.host
  username               = module.cluster.kubernetes.username
  password               = module.cluster.kubernetes.password
  client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
  client_key             = base64decode(module.cluster.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubernetes.host
    username               = module.cluster.kubernetes.username
    password               = module.cluster.kubernetes.password
    client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
    client_key             = base64decode(module.cluster.kubernetes.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
    load_config_file       = false
  }
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
    registry = {
      scope = var.registry.resource_group.id
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
  }
}

module "monitor" {
  source    = "./modules/monitor"
  name      = local.monitor.name
  location  = local.monitor.location
  retention = local.monitor.retention
  enabled   = local.monitor.enabled
}

# NETWORK

locals {
  network = {
    name       = try(var.network.name, format("%s-network-%s", var.name, module.suffix.output))
    location   = var.location
    dns_prefix = try(var.network.dns_prefix, var.cluster.dns_prefix, var.cluster.name, var.name)
    subnets    = try(var.network.subnets, [{ name = "primary" }])
  }
}

module "network" {
  source     = "./modules/network"
  name       = local.network.name
  location   = local.network.location
  dns_prefix = local.network.dns_prefix

  subnets = [
    for subnet in local.network.subnets : {
      name = subnet.name
      bits = try(subnet.bits, 8)
    }
  ]
}

# ROLE-BASED ACCESS CONTROL (RBAC)

locals {
  rbac = {
    name           = try(var.rbac.name, format("%s-cluster-%s-rbac", var.name, module.suffix.output))
    administrators = try(var.rbac.administrators, [])
    consent        = try(var.rbac.consent, false)
    enabled        = try(var.rbac.enabled, true)
  }
}

module "rbac" {
  source  = "./modules/rbac"
  name    = local.rbac.name
  consent = local.rbac.consent
  enabled = local.rbac.enabled

  groups = {
    admin = {
      label   = "Azure Kubernetes Service Administrators"
      members = local.rbac.administrators
      enabled = local.rbac.enabled && length(local.rbac.administrators) > 0
    }
  }
}

# CLUSTER

locals {
  cluster = {
    name                     = try(var.cluster.name, format("%s-cluster-%s", var.name, module.suffix.output))
    location                 = var.location
    node_resource_group_name = try(var.cluster.node_resource_group_name, format("%s-nodepool-%s-rg", var.name, module.suffix.output))
    dns_prefix               = try(var.cluster.dns_prefix, var.network.dns_prefix, var.cluster.name, var.name)
    dashboard                = try(var.cluster.dashboard, {})
    kured                    = try(var.cluster.kured, {})
    kubernetes_version       = try(var.cluster.kubernetes_version, null)
    pools                    = try(var.cluster.pools, { primary = {} })
    authorized_ip_ranges     = try(var.cluster.authorized_ip_ranges, [])
  }
}

module "cluster" {
  source                   = "./modules/cluster"
  name                     = local.cluster.name
  location                 = local.cluster.location
  monitor                  = module.monitor
  network                  = module.network
  service_principal        = module.service_principal
  rbac                     = module.rbac
  dns_prefix               = local.cluster.dns_prefix
  dashboard                = local.cluster.dashboard
  kured                    = local.cluster.kured
  kubernetes_version       = local.cluster.kubernetes_version
  node_resource_group_name = local.cluster.node_resource_group_name
  pools                    = local.cluster.pools
  authorized_ip_ranges     = local.cluster.authorized_ip_ranges
}
