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

  rbac = {
    enabled        = true
    administrators = ["daniel.balcomb@outlook.com"]
  }
}
