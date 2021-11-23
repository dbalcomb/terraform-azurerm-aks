locals {
  default_exclude_fields = [
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
}

resource "kubernetes_config_map" "main" {
  metadata {
    name      = "container-azm-ms-agentconfig"
    namespace = "kube-system"
  }

  data = {
    "schema-version" = "v1"
    "prometheus-data-collection-settings" = templatefile("${path.module}/templates/prometheus.tpl", {
      enabled        = try(var.prometheus.enabled, false)
      interval       = format("%q", tostring(try(var.prometheus.interval, "1m")))
      include_fields = [for s in try(var.prometheus.include_fields, []) : format("%q", s)]
      exclude_fields = [for s in try(var.prometheus.exclude_fields, local.default_exclude_fields) : format("%q", s)]
    })
    "log-data-collection-settings" = templatefile("${path.module}/templates/log.tpl", {
      env_enabled               = try(var.log.env_enabled, false)
      enrich_enabled            = try(var.log.enrich_enabled, false)
      stdout_enabled            = try(var.log.stdout_enabled, false)
      stdout_exclude_namespaces = [for s in try(var.log.stdout_exclude_namespaces, ["kube-system"]) : format("%q", s)]
      stderr_enabled            = try(var.log.stderr_enabled, false)
      stderr_exclude_namespaces = [for s in try(var.log.stderr_exclude_namespaces, ["kube-system"]) : format("%q", s)]
    })
  }
}
