[prometheus_data_collection_settings.cluster]
  interval = "1m"
  monitor_kubernetes_pods = true
  fielddrop = [
    %{~ for field in fields_exclude ~}
    "${field}",
    %{~ endfor ~}
  ]
