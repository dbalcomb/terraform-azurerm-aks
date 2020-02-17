# Role-Based Access Control (RBAC) Client Component

This module configures the Role-Based Access Control (RBAC) client component
that handles authentication with the Kubernetes CLI (`kubectl`).

## Notes

- The client component uses a list of reply URLs for authentication as gathered
  from Microsoft documentation and the `aks-commander` project.

## References

- [AAD Client Application](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-integration)
- [AAD Client Component](https://docs.microsoft.com/en-gb/azure/aks/azure-ad-integration-cli#create-azure-ad-client-component)
- [AKS Commander](https://github.com/rhummelmose/aks-commander/blob/master/terraform/rbac/main.tf#L15)
