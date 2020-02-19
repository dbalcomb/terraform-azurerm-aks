# Ingress

This module configures the resources required to enable routing and certificate
handling in the Azure Kubernetes Service (AKS) cluster.

## Modules

- [Certificate Manager](cert-manager/README.md)
- [Controller](controller/README.md)
- [Routes](routes/README.md)

## Notes

- Shared IP addresses for ingress and egress are not currently supported. This
  means that the controller needs to be assigned a new separate IP.

## References

- [AKS Networking Ingress](https://docs.microsoft.com/en-gb/azure/aks/concepts-network#ingress-controllers)
- [Standard SKU Load Balancer](https://docs.microsoft.com/en-gb/azure/aks/load-balancer-standard)
- [Shared Public IP](https://github.com/kubernetes-sigs/cloud-provider-azure/issues/267)
- [Static IP Conflict](https://github.com/Azure/AKS/issues/1359)
- [IP Per Service](https://github.com/MicrosoftDocs/azure-docs/issues/10816#issuecomment-400851710)
- [Egress Traffic Overview](https://docs.microsoft.com/en-gb/azure/aks/egress#egress-traffic-overview)
- [Load Balancer Error](https://stackoverflow.com/questions/49994073/load-balancer-publicipreferencedbymultipleipconfigs-error-on-restart)
- [Multiple IP References](https://github.com/Azure/ACS/issues/102)
