terraform {
  required_version = ">= 0.12"
}

module "cluster" {
  source            = "./modules/cluster"
  name              = var.name
  location          = var.location
  service_principal = var.service_principal
  dns_prefix        = var.dns_prefix
}
