module "acr" {
  source     = "github.com/dbalcomb/terraform-azurerm-acr"
  name       = "acr"
  location   = "uksouth"
  dns_prefix = "dbalcombacr"
}

module "aks" {
  source     = "../../" # github.com/dbalcomb/terraform-azurerm-aks
  name       = "aks"
  location   = "uksouth"
  dns_prefix = "dbalcombaks"
  registry   = module.acr

  ingress = {
    enabled = true
    routes = {
      example = {
        rules = [
          {
            host = "example.com"
            paths = [
              {
                path                 = "/"
                backend_service_name = "example"
                backend_service_port = 80
              }
            ]
          }
        ]
      }
    }
  }
}
