# Cluster Role-Based Access Control (RBAC)

This module configures the Role-Based Access Control (RBAC) resources that can
only be configured after the creation of the Azure Kubernetes Service (AKS)
cluster. This includes the Azure role assignments and Kubernetes role bindings
that are needed to map access to resources within Azure to resources within
Kubernetes.

## References

- [AAD RBAC Overview](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-rbac)
- [Control Kubernetes Access](https://docs.microsoft.com/en-gb/azure/aks/control-kubeconfig-access)
- [Authentication Best Practices](https://docs.microsoft.com/en-gb/azure/aks/operator-best-practices-identity)
