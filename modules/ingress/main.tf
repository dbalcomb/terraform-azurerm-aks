data "helm_repository" "main" {
  count = var.enabled ? 1 : 0
  name  = "stable"
  url   = "https://kubernetes-charts.storage.googleapis.com"
}

resource "kubernetes_namespace" "main" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.name
  }
}

resource "helm_release" "main" {
  count      = var.enabled ? 1 : 0
  name       = var.name
  namespace  = kubernetes_namespace.main.0.metadata.0.name
  repository = data.helm_repository.main.0.metadata.0.name
  chart      = "nginx-ingress"

  set {
    name  = "controller.replicaCount"
    value = var.replicas
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = var.ip_address
  }

  set {
    name  = "controller.service.annotations.service.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = var.resource_group_name
  }

  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.service.annotations.prometheus\\.io/scrape"
    value = "true"
  }

  set {
    name  = "controller.metrics.service.annotations.prometheus\\.io/path"
    value = "/metrics"
  }

  set {
    name  = "controller.metrics.service.annotations.prometheus\\.io/port"
    value = "10254"
  }
}

module "cert_manager" {
  source  = "./cert-manager"
  enabled = var.enabled
}
