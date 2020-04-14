module "aks" {
  source   = "../../" # github.com/dbalcomb/terraform-azurerm-aks
  name     = "aks"
  location = "uksouth"

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
