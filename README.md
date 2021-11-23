# Azure Kubernetes Service (AKS) Terraform Modules

Terraform modules for [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-gb/services/kubernetes-service/).

## Upgrade

Upgrading to use the `azurerm` provider 2.0 requires the following commands as
the `user_impersonation` scope is no longer automatically provided. The scope
identifiers can be obtained from the existing state.

```sh
terraform import module.${MODULE_NAME}.module.service_principal.random_uuid.user_impersonation_scope ${SCOPE_ID_1}
terraform import module.${MODULE_NAME}.module.rbac.module.server.random_uuid.user_impersonation_scope ${SCOPE_ID_2}
```

## Modules

This project provides the following submodules to configure the cluster:

- [Cluster](modules/cluster/README.md)
- [Group](modules/group/README.md)
- [Insights](modules/insights/README.md)
- [Monitor](modules/monitor/README.md)
- [Network](modules/network/README.md)
- [Service Principal](modules/service-principal/README.md)

## Dependencies

This project requires the following external dependencies:

- [Azure Container Registry Module](https://github.com/dbalcomb/terraform-azurerm-acr)

## Related

- [Azure Kubernetes Service Ingress](https://github.com/dbalcomb/terraform-azurerm-aks-ingress)

## To do

The following is a list of potential future features that need further support
and/or investigation before adding them to the project:

- [API Server](https://docs.microsoft.com/en-gb/azure/aks/api-server-authorized-ip-ranges)
- [Azure Database for PostgreSQL](https://docs.microsoft.com/en-gb/azure/postgresql/concepts-aks)
- [Azure Dev Spaces](https://docs.microsoft.com/en-gb/azure/dev-spaces/)
- [Azure File Share Volumes](https://docs.microsoft.com/en-gb/azure/aks/azure-files-volume)
- [Azure Policy](https://docs.microsoft.com/en-gb/azure/governance/policy/concepts/rego-for-aks)
- [Disk Encryption Keys](https://docs.microsoft.com/en-gb/azure/aks/azure-disk-customer-managed-keys)
- [Network Policies](https://docs.microsoft.com/en-gb/azure/aks/use-network-policies)
- [Pod Security Policies](https://docs.microsoft.com/en-gb/azure/aks/use-pod-security-policies)

### Blockers

- [Pod Security Policy Resource](https://github.com/terraform-providers/terraform-provider-kubernetes/pull/624)

## References

- [Container Registry Integration](https://docs.microsoft.com/en-gb/azure/aks/cluster-container-registry-integration)
- [Container Registry Authentication](https://docs.microsoft.com/en-gb/azure/container-registry/container-registry-auth-kubernetes)
