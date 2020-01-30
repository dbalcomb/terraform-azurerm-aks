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
}

resource "azurerm_virtual_network" "main" {
  name                = format("%s-vnet", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "main" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = each.value.cidr
}

resource "azurerm_public_ip" "main" {
  name                = format("%s-ip", var.name)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = var.dns_prefix
}

resource "azurerm_role_assignment" "main" {
  principal_id         = var.service_principal.id
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Network Contributor"
}
