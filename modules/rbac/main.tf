module "server" {
  source  = "./apps/server"
  name    = format("%s-server", var.name)
  consent = var.consent
}

module "client" {
  source = "./apps/client"
  name   = format("%s-client", var.name)
  server = module.server
}
