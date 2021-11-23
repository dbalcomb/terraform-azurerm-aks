resource "azurerm_role_assignment" "main" {
  count                = var.enabled ? 1 : 0
  principal_id         = var.service_principal.id
  scope                = var.cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count                      = var.debug ? 1 : 0
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
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }
}
