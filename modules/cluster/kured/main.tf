resource "helm_release" "main" {
  count      = var.enabled ? 1 : 0
  name       = var.name
  namespace  = "kube-system"
  repository = "https://weaveworks.github.io/kured"
  chart      = "kured"

  set {
    name  = "image.tag"
    value = "master-f6e4062"
  }

  set {
    name  = "nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "extraArgs.time-zone"
    value = "Local"
  }

  set {
    name  = "extraArgs.start-time"
    value = "2am"
  }

  set {
    name  = "extraArgs.end-time"
    value = "4am"
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
