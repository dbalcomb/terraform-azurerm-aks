# Cluster Kured

This module configures the `kured` utility which is used to enable automatic
updates and restarting of Kubernetes host nodes.

## Notes

- In order for host nodes to be restarted `kured` will cordon and drain the
  node so that no pods are scheduled on it. This means that for a single node
  pool, or for pods that cannot run on another node, the services that the pods
  provide will be offline during restarts. It is possible for pod disruption
  budgets to prevent this but the impact will be that host nodes are unable to
  restart to complete security updates.
- The Helm chart includes the ability to limit restarts to a certain time
  period. This happens to be between 4am and 6am.

## References

- [Using Kured](https://docs.microsoft.com/en-gb/azure/aks/node-updates-kured)
- [Helm Install](https://github.com/MicrosoftDocs/azure-docs/pull/45988)
- [Helm Chart](https://github.com/helm/charts/tree/master/stable/kured)
