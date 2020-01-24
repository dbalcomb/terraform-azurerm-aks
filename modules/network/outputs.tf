output "resource_group" {
  description = "The resource group"
  value       = azurerm_resource_group.main
}

output "vnet" {
  description = "The virtual network"
  value       = azurerm_virtual_network.main
}

output "subnet" {
  description = "The virtual network subnet"
  value       = azurerm_subnet.cluster
}

output "dns_service_ip" {
  description = "The DNS service IP"
  value       = "10.0.0.10"
}

output "service_cidr" {
  description = "The Kubernetes service address range"
  value       = "10.0.0.0/16"
}

output "docker_bridge_cidr" {
  description = "The Docker Bridge address"
  value       = "172.17.0.1/16"
}
