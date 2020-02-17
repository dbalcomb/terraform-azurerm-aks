# Ingress Controller

This module configures the ingress controller for the Azure Kubernetes Service
(AKS) cluster. The ingress controller is responsible for routing external
traffic through the cluster to the appropriate service.

## Notes

- The controller uses the `nginx-ingress` utility as described by Microsoft in
  the AKS documentation. It may be possible to use `traefik` as an alternative
  but documentation is lacking.

## References

- [Create an Ingress Controller](https://docs.microsoft.com/en-gb/azure/aks/ingress-basic)
- [Ingress Helm Chart](https://github.com/helm/charts/tree/master/stable/nginx-ingress)
- [Ingress Controller with Static IP](https://docs.microsoft.com/en-gb/azure/aks/ingress-static-ip)
