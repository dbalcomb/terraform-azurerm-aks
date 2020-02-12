data "helm_repository" "main" {
  count = var.enabled ? 1 : 0
  name  = "stable"
  url   = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "main" {
  count      = var.enabled ? 1 : 0
  name       = var.name
  namespace  = "kube-system"
  repository = data.helm_repository.main.0.metadata.0.name
  chart      = "kured"

  set {
    name  = "nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "autolock.enabled"
    value = true
  }

  set {
    name  = "podAnnotations.prometheus\\.io/scrape"
    value = "true"
  }

  set {
    name  = "podAnnotations.prometheus\\.io/path"
    value = "/metrics"
  }

  set {
    name  = "podAnnotations.prometheus\\.io/port"
    value = "8080"
  }
}
