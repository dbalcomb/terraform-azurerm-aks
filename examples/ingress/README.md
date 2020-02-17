# Example: Ingress

This example creates an Azure Kubernetes Service (AKS) cluster with an ingress
route that maps the domain `example.com` to a backend service called `example`.

## Notes

- The creation of the `example` backend service is not included in the example
  as there is currently no means of creating an ingress backend in the module.
