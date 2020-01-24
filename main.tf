terraform {
  required_version = ">= 0.12"
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name
}

module "log_analytics" {
  source    = "./modules/log-analytics"
  name      = format("%s-la", var.name)
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
  network           = module.network
  service_principal = module.service_principal
  log_analytics     = module.log_analytics
  dns_prefix        = var.dns_prefix
}
