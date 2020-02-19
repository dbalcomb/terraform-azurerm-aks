module "controller" {
  source   = "./controller"
  name     = var.name
  network  = var.network
  replicas = var.replicas
  enabled  = var.enabled
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
