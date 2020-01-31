module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name

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

module "monitor" {
  source    = "./modules/monitor"
  name      = format("%s-monitor", var.name)
  location  = var.location
  retention = var.retention
}

module "network" {
  source     = "./modules/network"
  name       = format("%s-network", var.name)
  location   = var.location
  dns_prefix = var.dns_prefix

  subnets = [
    for subnet in var.subnets : {
      name = subnet.name
      bits = lookup(subnet, "bits", 8)
    }
  ]
}

module "rbac" {
  source  = "./modules/rbac"
  name    = format("%s-rbac", var.name)
  consent = false
  enabled = try(var.rbac.enabled, true)
}

module "cluster" {
  source            = "./modules/cluster"
  name              = var.name
  location          = var.location
  monitor           = module.monitor
  network           = module.network
  service_principal = module.service_principal
  rbac              = module.rbac
  dns_prefix        = var.dns_prefix
  administrators    = var.administrators

  pools = {
    for name, pool in var.pools : name => {
      subnet         = lookup(pool, "subnet", "primary")
      size           = lookup(pool, "size", "Standard_D2s_v3")
      scale          = lookup(pool, "scale", 1)
      auto_scale     = lookup(pool, "auto_scale", true)
      auto_scale_min = lookup(pool, "auto_scale_min", 1)
      auto_scale_max = lookup(pool, "auto_scale_max", 3)
      pod_limit      = lookup(pool, "pod_limit", 250)
      disk_size      = lookup(pool, "disk_size", 30)
    }
  }
}
