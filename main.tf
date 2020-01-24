terraform {
  required_version = ">= 0.12"
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name
}

module "monitor" {
  source    = "./modules/monitor"
  name      = format("%s-mon", var.name)
  location  = var.location
  retention = var.retention
}

module "network" {
  source   = "./modules/network"
  name     = format("%s-net", var.name)
  location = var.location
}

module "cluster" {
  source            = "./modules/cluster"
  name              = var.name
  location          = var.location
  monitor           = module.monitor
  network           = module.network
  service_principal = module.service_principal
  dns_prefix        = var.dns_prefix
}
