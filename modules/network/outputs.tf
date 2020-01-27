output "resource_group" {
  description = "The resource group"
  value       = azurerm_resource_group.main
}

output "vnet" {
  description = "The virtual network"
  value       = azurerm_virtual_network.main
}

output "subnets" {
  description = "The virtual network subnets"
  value       = azurerm_subnet.main
}

output "dns_service_ip" {
  description = "The DNS service IP"
  value       = local.dns_service_ip
}

output "service_cidr" {
  description = "The Kubernetes service address range"
  value       = local.service_cidr
}

output "docker_bridge_cidr" {
  description = "The Docker Bridge address"
  value       = "172.17.0.1/16"
}
