# AKS / Monitor

This module configures the monitoring resources that are required by the Azure
Kubernetes Service (AKS) cluster to enable monitoring.

## Notes

- This module provides the required resources needed before the creation of an
  Azure Kubernetes Service (AKS) cluster. For the resources that need to be
  configured after the cluster creation see [this module](../cluster/monitor/README.md).

## References

- [Azure Monitor for Containers](https://docs.microsoft.com/en-gb/azure/azure-monitor/insights/container-insights-overview)
