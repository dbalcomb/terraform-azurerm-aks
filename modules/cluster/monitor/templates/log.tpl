[log_collection_settings]
  [log_collection_settings.stdout]
    enabled = ${stdout_enabled}
    exclude_namespaces = [
      %{~ for namespace in stdout_exclude_namespaces ~}
      "${namespace}",
      %{~ endfor ~}
    ]
  [log_collection_settings.stderr]
    enabled = ${stderr_enabled}
    exclude_namespaces = [
      %{~ for namespace in stderr_exclude_namespaces ~}
      "${namespace}",
      %{~ endfor ~}
    ]
  [log_collection_settings.env_var]
    enabled = ${envvar_enabled}
  [log_collection_settings.enrich_container_logs]
    enabled = ${enrich_enabled}
