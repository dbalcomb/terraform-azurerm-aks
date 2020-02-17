# AKS / Cluster

This module configures the Azure Kubernetes Service (AKS) cluster and combines
the various add-on modules that can be used to add extra functionality.

## Modules

- [Dashboard](dashboard/README.md)
- [Kured](kured/README.md)
- [Monitor](monitor/README.md)
- [RBAC](rbac/README.md)
- [Suffix](suffix/README.md)

## Notes

- The add-on functionality is included as submodules of the cluster due to the
  requirement to enable the functionality on the cluster resource itself rather
  than simply being able to enable it externally.

## References

- [Azure Kubernetes Service Tutorial](https://docs.microsoft.com/en-gb/azure/aks/tutorial-kubernetes-deploy-cluster)
