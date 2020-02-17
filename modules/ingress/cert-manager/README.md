# AKS / Ingress / Certificate Manager

This module configures the `cert-manager` utility to enable the management of
SSL certificates and the ability for the ingress controller to serve requests
via HTTPS.

## Notes

- At this time there is no official Terraform provider capable of handling
  custom resource definitions for Kubernetes. This means that there is a
  dependency on a locally-installed Kubernetes CLI (`kubectl`) in order to
  deploy the definitions needed for `cert-manager`.

## References

- [AKS Ingress Controller](https://docs.microsoft.com/en-gb/azure/aks/ingress-static-ip)
- [Securing nginx-ingress](https://cert-manager.io/docs/tutorials/acme/ingress/)
