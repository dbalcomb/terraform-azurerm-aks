locals {
  administrators = zipmap(var.administrators, var.administrators)
}

data "azuread_user" "main" {
  for_each            = local.administrators
  user_principal_name = each.value
}

resource "azuread_group" "main" {
  name = "Kubernetes Administrators"
}

resource "azuread_group_member" "main" {
  for_each         = data.azuread_user.main
  group_object_id  = azuread_group.main.id
  member_object_id = each.value.id
}

resource "azurerm_role_assignment" "main" {
  principal_id         = azuread_group.main.id
  scope                = var.cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
}

resource "kubernetes_cluster_role" "main" {
  metadata {
    name = var.name
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
  metadata {
    name = var.name
  }

  role_ref {
    name      = kubernetes_cluster_role.main.metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = azuread_group.main.id
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
  }
}
