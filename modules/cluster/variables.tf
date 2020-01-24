variable "name" {
  description = "The cluster name"
  type        = string
}

variable "location" {
  description = "The cluster location"
  type        = string
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

variable "log_analytics" {
  description = "The Log Analytics configuration"
  type = object({
    workspace = object({
      id = string
    })
  })
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}
