resource "azurerm_role_assignment" "monitor" {
  principal_id         = var.service_principal.id
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Monitoring Metrics Publisher"
}

resource "kubernetes_cluster_role" "monitor" {
  metadata {
    name = "aks-monitor"
  }

  rule {
    api_groups = ["", "metrics.k8s.io", "extensions", "apps"]
    resources  = ["pods", "pods/log", "events", "nodes", "deployments", "replicasets"]
    verbs      = ["get", "list", "top"]
  }
}

resource "kubernetes_cluster_role_binding" "monitor" {
  metadata {
    name = "aks-monitor"
  }

  role_ref {
    name      = kubernetes_cluster_role.monitor.metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = "clusterUser"
    kind      = "User"
    api_group = "rbac.authorization.k8s.io"
  }
}
