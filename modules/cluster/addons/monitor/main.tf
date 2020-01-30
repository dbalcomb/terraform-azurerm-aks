resource "azurerm_role_assignment" "main" {
  principal_id         = var.service_principal.id
  scope                = var.cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
}

resource "kubernetes_cluster_role" "main" {
  metadata {
    name = var.name
  }

  rule {
    api_groups = ["", "metrics.k8s.io", "extensions", "apps"]
    resources  = ["pods", "pods/log", "events", "nodes", "deployments", "replicasets"]
    verbs      = ["get", "list", "top"]
  }
}

resource "kubernetes_cluster_role_binding" "main" {
  metadata {
    name = var.name
  }

  role_ref {
    name      = kubernetes_cluster_role.main.metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = "clusterUser"
    kind      = "User"
    api_group = "rbac.authorization.k8s.io"
  }
}