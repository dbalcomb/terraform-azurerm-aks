resource "azurerm_role_assignment" "main" {
  count                = var.enabled ? 1 : 0
  principal_id         = var.service_principal.id
  scope                = var.cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
}

resource "kubernetes_config_map" "main" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "container-azm-ms-agentconfig"
    namespace = "kube-system"
  }

  data = {
    "schema-version" = "v1"
    "prometheus-data-collection-settings" = templatefile("${path.module}/templates/prometheus.tpl", {
      fields_exclude = var.debug ? [] : [
        "go_gc_duration_seconds",
        "go_gc_duration_seconds_count",
        "go_gc_duration_seconds_sum",
        "go_goroutines",
        "go_info",
        "go_memstats_alloc_bytes",
        "go_memstats_alloc_bytes_total",
        "go_memstats_buck_hash_sys_bytes",
        "go_memstats_frees_total",
        "go_memstats_gc_cpu_fraction",
        "go_memstats_gc_sys_bytes",
        "go_memstats_heap_alloc_bytes",
        "go_memstats_heap_idle_bytes",
        "go_memstats_heap_inuse_bytes",
        "go_memstats_heap_objects",
        "go_memstats_heap_released_bytes",
        "go_memstats_heap_sys_bytes",
        "go_memstats_last_gc_time_seconds",
        "go_memstats_lookups_total",
        "go_memstats_mallocs_total",
        "go_memstats_mcache_inuse_bytes",
        "go_memstats_mcache_sys_bytes",
        "go_memstats_mspan_inuse_bytes",
        "go_memstats_mspan_sys_bytes",
        "go_memstats_next_gc_bytes",
        "go_memstats_other_sys_bytes",
        "go_memstats_stack_inuse_bytes",
        "go_memstats_stack_sys_bytes",
        "go_memstats_sys_bytes",
        "go_threads",
        "process_cpu_seconds_total",
        "process_max_fds",
        "process_open_fds",
        "process_resident_memory_bytes",
        "process_start_time_seconds",
        "process_virtual_memory_bytes",
        "process_virtual_memory_max_bytes",
        "promhttp_metric_handler_requests_in_flight",
        "promhttp_metric_handler_requests_total",
      ]
    })
    "log-data-collection-settings" = templatefile("${path.module}/templates/log.tpl", {
      envvar_enabled            = false
      enrich_enabled            = false
      stdout_enabled            = var.debug
      stdout_exclude_namespaces = var.debug ? [] : ["kube-system"]
      stderr_enabled            = true
      stderr_exclude_namespaces = var.debug ? [] : ["kube-system"]
    })
  }
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
