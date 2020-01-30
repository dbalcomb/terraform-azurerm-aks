terraform {
  required_version = ">= 0.12"
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name

  role_assignments = {
    network = {
      scope = module.network.resource_group.id
      role  = "Network Contributor"
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
  source            = "./modules/network"
  name              = format("%s-network", var.name)
  location          = var.location
  dns_prefix        = var.dns_prefix
  service_principal = module.service_principal

  subnets = [
    for subnet in var.subnets : {
      name = subnet.name
      bits = lookup(subnet, "bits", 8)
    }
  ]
}

module "rbac_server_application" {
  source  = "./modules/rbac-server-application"
  name    = format("%s-rbac-server", var.name)
  consent = false
}

module "rbac_client_application" {
  source = "./modules/rbac-client-application"
  name   = format("%s-rbac-client", var.name)
  server = module.rbac_server_application
}

module "cluster" {
  source                  = "./modules/cluster"
  name                    = var.name
  location                = var.location
  monitor                 = module.monitor
  network                 = module.network
  service_principal       = module.service_principal
  rbac_server_application = module.rbac_server_application
  rbac_client_application = module.rbac_client_application
  dns_prefix              = var.dns_prefix
  administrators          = var.administrators

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
