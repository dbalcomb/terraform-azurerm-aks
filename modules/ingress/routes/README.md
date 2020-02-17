# AKS / Ingress / Routes

This module configures the ingress route resources that are used to configure
the ingress controller.

## Notes

- At this time there is no support for the `rewrite-target` annotation or for
  specifying certificate information.

## References

- [Create an Ingress Route](https://docs.microsoft.com/en-gb/azure/aks/ingress-static-ip#create-an-ingress-route)
- [Ingress Resource](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Rewrite Annotations](https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/rewrite)
