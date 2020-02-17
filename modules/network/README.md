# AKS / Network

This module configures the networking resources that are required by the Azure
Kubernetes Service (AKS) cluster.

## Notes

- Currently only supports advanced Azure CNI networking resources.
- [Limited support for node pools across different subnets](https://github.com/Azure/AKS/issues/1338).

## References

- [Networking Best Practices](https://docs.microsoft.com/en-gb/azure/aks/operator-best-practices-network)
- [Azure CNI Networking](https://docs.microsoft.com/en-gb/azure/aks/configure-azure-cni)
- [Egress IP Address](https://docs.microsoft.com/en-gb/azure/aks/egress)
