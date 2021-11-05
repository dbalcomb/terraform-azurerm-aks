locals {
  address_blocks = cidrsubnets(var.address_space, 8, var.subnets.*.bits...)
  dns_service_ip = cidrhost(local.address_blocks.0, 10)
  service_cidr   = local.address_blocks.0
  subnets = {
    for index, subnet in var.subnets : subnet.name => {
      name = subnet.name
      cidr = local.address_blocks[index + 1]
    }
    if subnet.name != null
  }
}

resource "azurerm_resource_group" "main" {
  name     = format("%s-rg", var.name)
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = format("%s-vnet", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.cidr]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_public_ip" "main" {
  name                = format("%s-ip", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = var.dns_prefix
  tags                = var.tags
}
