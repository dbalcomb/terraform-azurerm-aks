terraform {
  required_version = ">= 0.12"
}

resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg", var.prefix)
  location = var.location
}
