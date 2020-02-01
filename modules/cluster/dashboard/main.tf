resource "kubernetes_cluster_role" "main" {
  metadata {
    name = var.name
  }

  rule {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "endpoints",
      "persistentvolumeclaims",
      "pods",
      "replicationcontrollers",
      "replicationcontrollers/scale",
      "serviceaccounts",
      "services",
      "nodes",
      "persistentvolumeclaims",
      "persistentvolumes",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "",
    ]
    resources = [
      "bindings",
      "events",
      "limitranges",
      "namespaces/status",
      "pods/log",
      "pods/status",
      "replicationcontrollers/status",
      "resourcequotas",
      "resourcequotas/status",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "",
    ]
    resources = [
      "namespaces",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "apps",
    ]
    resources = [
      "daemonsets",
      "deployments",
      "deployments/scale",
      "replicasets",
      "replicasets/scale",
      "statefulsets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "autoscaling",
    ]
    resources = [
      "horizontalpodautoscalers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "batch",
    ]
    resources = [
      "cronjobs",
      "jobs",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "extensions",
    ]
    resources = [
      "daemonsets",
      "deployments",
      "deployments/scale",
      "ingresses",
      "networkpolicies",
      "replicasets",
      "replicasets/scale",
      "replicationcontrollers/scale",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "policy",
    ]
    resources = [
      "poddisruptionbudgets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "networking.k8s.io",
    ]
    resources = [
      "networkpolicies",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "storage.k8s.io",
    ]
    resources = [
      "storageclasses",
      "volumeattachments",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = [
      "rbac.authorization.k8s.io",
    ]
    resources = [
      "clusterrolebindings",
      "clusterroles",
      "roles",
      "rolebindings",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
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
    name      = "kubernetes-dashboard"
    namespace = "kube-system"
    kind      = "ServiceAccount"
    api_group = "rbac.authorization.k8s.io"
  }
}
