module "server" {
  source  = "./server"
  name    = format("%s-server", var.name)
  consent = var.consent
  enabled = var.enabled
}

module "client" {
  source  = "./client"
  name    = format("%s-client", var.name)
  server  = module.server
  enabled = var.enabled
}

module "groups" {
  source = "./groups"
  config = var.groups
}
