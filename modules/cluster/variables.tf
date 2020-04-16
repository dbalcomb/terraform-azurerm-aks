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
  default     = null
  type        = any
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
    ip = object({
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
    id             = string
    application_id = string
    secret         = string
  })
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}

variable "pools" {
  description = "The cluster node pool configuration"
  default = {
    primary = {}
  }
  type = any
}

variable "rbac" {
  description = "The role-based access control configuration"
  default     = null
  type        = any
}

variable "dashboard" {
  description = "The dashboard configuration"
  default     = null
  type        = any
}

variable "kured" {
  description = "The kured configuration"
  default     = null
  type        = any
}

variable "node_resource_group_name" {
  description = "The node resource group name"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version"
  default     = null
  type        = string
}

variable "authorized_ip_ranges" {
  description = "The API server authorized IP ranges"
  default     = []
  type        = list(string)
}

variable "debug" {
  description = "Enable debugging"
  default     = false
  type        = bool
}

variable "tags" {
  description = "The resource tags"
  default     = {}
  type        = map(string)
}
