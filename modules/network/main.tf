terraform {
  required_providers {
    azurerm = ">= 1.41"
  }
}

resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = format("%s-vnet", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "cluster" {
  name                 = "cluster"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.240.0.0/16"
}
