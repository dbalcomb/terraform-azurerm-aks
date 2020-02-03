resource "azurerm_role_assignment" "main" {
  for_each             = var.groups
  principal_id         = each.value.id
  scope                = var.cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
}

resource "kubernetes_cluster_role" "main" {
  for_each = var.groups

  metadata {
    name = format("%s-%s", var.name, each.key)
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "main" {
  for_each = var.groups

  metadata {
    name = format("%s-%s", var.name, each.key)
  }

  role_ref {
    name      = kubernetes_cluster_role.main[each.key].metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = each.value.id
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
  }
}
