# Cluster Dashboard

This module configures the resources required to enable read-only access to the
Kubernetes dashboard on RBAC-enabled clusters.

## Notes

- The use of Role-Based Access Control (RBAC) means that this module is required
  otherwise the Kubernetes dashboard will be inaccessible due to permissions
  errors.
- The official Azure documentation suggests using the built-in *cluster-admin*
  role to grant access but admits that it is not secure.

## References

- [Access Dashboard](https://docs.microsoft.com/en-gb/azure/aks/kubernetes-dashboard)
- [Read-Only Dashboard](https://blog.cowger.us/2018/07/03/a-read-only-kubernetes-dashboard.html)
- [Read-Only Cluster Role](https://github.com/helm/charts/blob/master/stable/kubernetes-dashboard/templates/clusterrole-readonly.yaml)
- [Read-Only Access Gist](https://gist.github.com/ams0/677fe4fb1d523afef6e1cebb6d4a6035)
