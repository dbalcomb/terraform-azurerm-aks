locals {
  administrators = zipmap(var.administrators, var.administrators)
}

data "azuread_user" "admin" {
  for_each            = local.administrators
  user_principal_name = each.value
}

resource "azuread_group" "admin" {
  name = "Kubernetes Administrators"
}

resource "azuread_group_member" "admin" {
  for_each         = data.azuread_user.admin
  group_object_id  = azuread_group.admin.id
  member_object_id = each.value.id
}

resource "azurerm_role_assignment" "admin" {
  principal_id         = azuread_group.admin.id
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
}

resource "kubernetes_cluster_role" "admin" {
  metadata {
    name = "aks-admin"
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

resource "kubernetes_cluster_role_binding" "admin" {
  metadata {
    name = "aks-admin"
  }

  role_ref {
    name      = kubernetes_cluster_role.admin.metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = azuread_group.admin.id
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
  }
}
