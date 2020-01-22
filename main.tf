terraform {
  required_version = ">= 0.12"
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name
}

module "cluster" {
  source            = "./modules/cluster"
  name              = var.name
  location          = var.location
  service_principal = module.service_principal
  dns_prefix        = var.dns_prefix
}
