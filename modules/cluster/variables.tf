variable "name" {
  description = "The cluster name"
  type        = string
}

variable "location" {
  description = "The cluster location"
  type        = string
}

variable "monitor" {
  description = "The monitor configuration"
  type = object({
    log_analytics_workspace = object({
      id = string
    })
  })
}

variable "network" {
  description = "The network configuration"
  type = object({
    dns_service_ip     = string
    service_cidr       = string
    docker_bridge_cidr = string
    resource_group = object({
      id = string
    })
    subnet = object({
      id = string
    })
  })
}

variable "service_principal" {
  description = "The cluster service principal"
  type = object({
    id     = string
    secret = string
  })
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}
