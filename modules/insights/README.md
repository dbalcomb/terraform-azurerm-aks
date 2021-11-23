# Insights

This module configures the log collection and prometheus scraping settings for
containers in the cluster.

## Notes

- This module is optional but is required to override the default configuration
  when monitoring is enabled on the cluster which may cause excessive logging
  and high billing charges.
- This module is external to the cluster module as it defines a Kubernetes
  resource that uses a provider dependent on the output of the cluster module
  and so cannot be initially applied in the same step due to limitations in
  Terraform.

## References

- [Configure Prometheus Metric Scraping](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-prometheus-integration)
- [Configure Agent Collection Settings](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-agent-config)
