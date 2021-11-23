[prometheus_data_collection_settings.cluster]
  monitor_kubernetes_pods = ${enabled}
  interval = ${interval}
  fieldpass = [
    %{~ for field in include_fields ~}
    ${field},
    %{~ endfor ~}
  ]
  fielddrop = [
    %{~ for field in exclude_fields ~}
    ${field},
    %{~ endfor ~}
  ]
