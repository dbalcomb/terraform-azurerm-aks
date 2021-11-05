terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm    = "~> 2.83"
    helm       = "~> 2.3"
    kubernetes = "~> 2.6"
  }
}
