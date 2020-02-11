resource "kubernetes_namespace" "main" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.name
  }
}

resource "helm_release" "main" {
  count     = var.enabled ? 1 : 0
  name      = var.name
  namespace = kubernetes_namespace.main.0.metadata.0.name
  chart     = "stable/nginx-ingress"

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
}
