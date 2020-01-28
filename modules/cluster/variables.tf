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
    subnets = map(object({
      id = string
    }))
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

variable "pools" {
  description = "The cluster node pool configuration"
  default = {
    primary = {
      subnet         = "primary"
      size           = "Standard_D2s_v3"
      scale          = 1
      auto_scale     = true
      auto_scale_min = 1
      auto_scale_max = 3
      pod_limit      = 250
      disk_size      = 30
    }
  }
  type = map(object({
    subnet         = string
    size           = string
    scale          = number
    auto_scale     = bool
    auto_scale_min = number
    auto_scale_max = number
    pod_limit      = number
    disk_size      = number
  }))
}

variable "rbac_server_application" {
  description = "The role-based access control server application"
  default     = null
  type = object({
    id     = string
    secret = string
  })
}

variable "rbac_client_application" {
  description = "The role-based access control client application"
  default     = null
  type = object({
    id = string
  })
}

variable "administrators" {
  description = "The cluster administrator user email addresses"
  default     = []
  type        = list(string)
}
