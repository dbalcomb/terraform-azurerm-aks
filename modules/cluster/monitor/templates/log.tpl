[log_collection_settings]
  [log_collection_settings.stdout]
    enabled = ${stdout_enabled}
    exclude_namespaces = [%{ for ns in stdout_exclude_namespaces ~}"${ns}"%{ endfor ~}]
  [log_collection_settings.stderr]
    enabled = ${stderr_enabled}
    exclude_namespaces = [%{ for ns in stderr_exclude_namespaces ~}"${ns}"%{ endfor ~}]
  [log_collection_settings.env_var]
    enabled = ${envvar_enabled}
  [log_collection_settings.enrich_container_logs]
    enabled = ${enrich_enabled}
