# AKS / Cluster / Monitor

This module configures monitoring-related resources that must be set up after
the creation of the cluster. This is separate from the [monitoring resources](../../monitor/README.md)
that are required before the creation of the cluster.

## Notes

- Enables Kubernetes cluster metrics monitoring.
- Configures log data collection.
- Configures prometheus integration.

## References

- [Prometheus Integration](https://docs.microsoft.com/en-gb/azure/azure-monitor/insights/container-insights-prometheus-integration)
- [Agent Data Collection](https://docs.microsoft.com/en-gb/azure/azure-monitor/insights/container-insights-agent-config)
- [Setup Live Data](https://docs.microsoft.com/en-gb/azure/azure-monitor/insights/container-insights-livedata-setup)
