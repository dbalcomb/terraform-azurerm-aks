# Role-Based Access Control (RBAC)

This module simply wraps the Role-Based Access Control (RBAC) modules that are
required to enable Azure Active Directory (AAD) access control and permissions.

## Notes

- This module provides the required resources needed before the creation of an
  Azure Kubernetes Service (AKS) cluster. For the resources that need to be
  configured after the cluster creation see [this module](../cluster/rbac/README.md).

## Modules

- [Server](server/README.md)
- [Client](client/README.md)
- [Groups](client/README.md)

## References

- [AAD RBAC Overview](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-rbac)
- [AAD RBAC Integration](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-integration-cli)
- [Authentication Best Practices](https://docs.microsoft.com/en-gb/azure/aks/operator-best-practices-identity)
