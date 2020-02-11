resource "helm_release" "main" {
  count     = var.enabled ? 1 : 0
  name      = var.name
  namespace = "kube-system"
  chart     = "stable/kured"

  set {
    name  = "nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "autolock.enabled"
    value = true
  }
}
