data "helm_repository" "main" {
  count = var.enabled ? 1 : 0
  name  = "jetstack"
  url   = "https://charts.jetstack.io"
}

resource "null_resource" "definitions" {
  count = var.enabled ? 1 : 0

  triggers = {
    hash = sha256(file("${path.module}/templates/definitions.yml"))
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/definitions.yml --kubeconfig ${path.cwd}/kubeconfig"
  }

  provisioner "local-exec" {
    command = "kubectl delete -f ${path.module}/templates/definitions.yml --kubeconfig ${path.cwd}/kubeconfig"
    when    = destroy
  }

  depends_on = [
    kubernetes_namespace.main.0,
  ]
}

resource "kubernetes_namespace" "main" {
  count = var.enabled ? 1 : 0

  metadata {
    name = "cert-manager"
    labels = {
      "cert-manager.io/disable-validation" = "true"
    }
  }
}

resource "helm_release" "main" {
  count      = var.enabled ? 1 : 0
  name       = "cert-manager"
  namespace  = kubernetes_namespace.main.0.metadata.0.name
  repository = data.helm_repository.main.0.metadata.0.name
  chart      = "cert-manager"
  version    = "0.13"

  set {
    name  = "prometheus.enabled"
    value = "true"
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
    value = "9402"
  }

  depends_on = [
    null_resource.definitions.0,
  ]
}
