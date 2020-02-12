module "controller" {
  source              = "./controller"
  name                = var.name
  replicas            = var.replicas
  ip_address          = var.ip_address
  resource_group_name = var.resource_group_name
  enabled             = var.enabled
}

module "routes" {
  source     = "./routes"
  controller = module.controller
  routes     = var.routes
  enabled    = var.enabled
}

module "cert_manager" {
  source  = "./cert-manager"
  enabled = var.enabled
}
