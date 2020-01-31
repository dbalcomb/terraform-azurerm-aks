module "server" {
  source  = "./apps/server"
  name    = format("%s-server", var.name)
  consent = var.consent
  enabled = var.enabled
}

module "client" {
  source  = "./apps/client"
  name    = format("%s-client", var.name)
  server  = module.server
  enabled = var.enabled
}
