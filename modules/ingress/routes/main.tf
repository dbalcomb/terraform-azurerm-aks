resource "kubernetes_ingress" "main" {
  for_each = var.enabled ? var.routes : {}

  metadata {
    name      = format("%s-%s", var.controller.name, each.key)
    namespace = each.value.namespace

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    dynamic "rule" {
      for_each = each.value.rules

      content {
        host = rule.value.host

        http {
          dynamic "path" {
            for_each = rule.value.paths

            content {
              path = path.value.path

              backend {
                service_name = path.value.backend_service_name
                service_port = path.value.backend_service_port
              }
            }
          }
        }
      }
    }
  }
}
