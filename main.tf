terraform {
  required_version = ">= 0.12"
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name
}

module "monitor" {
  source    = "./modules/monitor"
  name      = format("%s-monitor", var.name)
  location  = var.location
  retention = var.retention
}

module "network" {
  source   = "./modules/network"
  name     = format("%s-network", var.name)
  location = var.location

  subnets = [
    for subnet in var.subnets : {
      name = subnet.name
      bits = lookup(subnet, "bits", 8)
    }
  ]
}

module "cluster" {
  source            = "./modules/cluster"
  name              = var.name
  location          = var.location
  monitor           = module.monitor
  network           = module.network
  service_principal = module.service_principal
  dns_prefix        = var.dns_prefix

  pools = {
    for name, pool in var.pools : name => {
      subnet    = lookup(pool, "subnet", "primary")
      size      = lookup(pool, "size", "Standard_D2s_v3")
      scale     = lookup(pool, "scale", 1)
      pod_limit = lookup(pool, "pod_limit", 250)
      disk_size = lookup(pool, "disk_size", 30)
    }
  }
}
