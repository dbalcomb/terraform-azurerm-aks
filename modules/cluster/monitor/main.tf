resource "azurerm_role_assignment" "main" {
  count                = var.enabled ? 1 : 0
  principal_id         = var.service_principal.id
  scope                = var.cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
}

resource "kubernetes_cluster_role" "main" {
  count = var.enabled ? 1 : 0

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
  count = var.enabled ? 1 : 0

  metadata {
    name = var.name
  }

  role_ref {
    name      = kubernetes_cluster_role.main.0.metadata.0.name
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = "clusterUser"
    kind      = "User"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_config_map" "main" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "container-azm-ms-agentconfig"
    namespace = "kube-system"
  }

  data = {
    "schema-version"                      = "v1"
    "prometheus-data-collection-settings" = file("${path.module}/templates/prometheus.tpl")
    "log-data-collection-settings" = templatefile("${path.module}/templates/log.tpl", {
      envvar_enabled            = false
      enrich_enabled            = false
      stdout_enabled            = false
      stdout_exclude_namespaces = ["kube-system"]
      stderr_enabled            = true
      stderr_exclude_namespaces = ["kube-system"]
    })
  }
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count                      = var.enabled ? 1 : 0
  name                       = "diagnostics"
  target_resource_id         = var.cluster.id
  log_analytics_workspace_id = var.monitor.log_analytics_workspace.id

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }

  log {
    category = "kube-apiserver"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
