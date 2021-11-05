provider "kubernetes" {
  host                   = module.cluster.kubernetes.host
  username               = module.cluster.kubernetes.username
  password               = module.cluster.kubernetes.password
  client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
  client_key             = base64decode(module.cluster.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubernetes.host
    username               = module.cluster.kubernetes.username
    password               = module.cluster.kubernetes.password
    client_certificate     = base64decode(module.cluster.kubernetes.client_certificate)
    client_key             = base64decode(module.cluster.kubernetes.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kubernetes.cluster_ca_certificate)
  }
}
