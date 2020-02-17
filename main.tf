provider "kubernetes" {
  host                   = module.cluster.kubernetes.host
  username               = module.cluster.kubernetes.username
  password               = module.cluster.kubernetes.password
  client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
  client_key             = base64decode(module.cluster.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubernetes.host
    username               = module.cluster.kubernetes.username
    password               = module.cluster.kubernetes.password
    client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
    client_key             = base64decode(module.cluster.kubernetes.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
    load_config_file       = false
  }
}

module "service_principal" {
  source = "./modules/service-principal"
  name   = var.name

  role_assignments = {
    network = {
      scope = module.network.resource_group.id
      role  = "Network Contributor"
    }
    registry = {
      scope = var.registry.resource_group.id
      role  = "AcrPull"
    }
  }
}

module "suffix" {
  source = "./modules/cluster/suffix"
  input  = var.dns_prefix
}

module "monitor" {
  source    = "./modules/monitor"
  name      = format("%s-monitor-%s", var.name, module.suffix.output)
  location  = var.location
  retention = try(var.monitor.retention, 30)
  enabled   = try(var.monitor.enabled, true)
}

module "network" {
  source     = "./modules/network"
  name       = format("%s-network-%s", var.name, module.suffix.output)
  location   = var.location
  dns_prefix = var.dns_prefix

  subnets = [
    for subnet in var.subnets : {
      name = subnet.name
      bits = lookup(subnet, "bits", 8)
    }
  ]
}

module "rbac" {
  source  = "./modules/rbac"
  name    = format("%s-cluster-%s-rbac", var.name, module.suffix.output)
  consent = false
  enabled = try(var.rbac.enabled, true)

  groups = {
    admin = {
      label   = "Azure Kubernetes Service Administrators"
      members = try(var.rbac.administrators, [])
      enabled = try(var.rbac.enabled, true) && length(try(var.rbac.administrators, [])) > 0
    }
  }
}

module "cluster" {
  source                   = "./modules/cluster"
  name                     = format("%s-cluster-%s", var.name, module.suffix.output)
  location                 = var.location
  monitor                  = module.monitor
  network                  = module.network
  service_principal        = module.service_principal
  rbac                     = module.rbac
  dns_prefix               = var.dns_prefix
  dashboard                = var.dashboard
  kured                    = var.kured
  kubernetes_version       = var.kubernetes_version
  node_resource_group_name = format("%s-nodepool-%s-rg", var.name, module.suffix.output)
  pools                    = var.pools
}

module "ingress" {
  source              = "./modules/ingress"
  name                = format("%s-cluster-%s-ingress", var.name, module.suffix.output)
  ip_address          = module.network.ip.ip_address
  resource_group_name = module.network.resource_group.name
  replicas            = try(var.ingress.replicas, 1)
  routes              = try(var.ingress.routes, {})
  enabled             = try(var.ingress.enabled, true)
}
