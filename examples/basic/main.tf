module "acr" {
  source     = "github.com/dbalcomb/terraform-azurerm-acr"
  name       = "acr"
  location   = "uksouth"
  dns_prefix = "dbalcombacr"
}

module "aks" {
  source   = "../../" # github.com/dbalcomb/terraform-azurerm-aks
  name     = "aks"
  location = "uksouth"
  registry = module.acr

  network = {
    dns_prefix = "dbalcombaks"
  }

  rbac = {
    enabled = true
    administrators = [
      "daniel.balcomb_outlook.com#EXT#@danielbalcomboutlook.onmicrosoft.com",
    ]
  }
}
