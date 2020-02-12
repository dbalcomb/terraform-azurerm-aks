variable "name" {
  description = "The ingress controller name"
  type        = string
}

variable "replicas" {
  description = "The ingress controller replica count"
  default     = 1
  type        = number
}

variable "ip_address" {
  description = "The ingress controller load balancer IP address"
  type        = string
}

variable "resource_group_name" {
  description = "The ingress controller load balancer resource group name"
  type        = string
}

variable "routes" {
  description = "The ingress route configuration"
  default     = {}
  type = map(object({
    rules = list(object({
      host = string
      paths = list(object({
        path                 = string
        backend_service_name = string
        backend_service_port = number
      }))
    }))
  }))
}

variable "enabled" {
  description = "Enable ingress"
  default     = true
  type        = bool
}
