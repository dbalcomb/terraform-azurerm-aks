variable "name" {
  description = "The ingress controller name"
  type        = string
}

variable "network" {
  description = "The network configuration"
  type = object({
    resource_group = object({
      name     = string
      location = string
    })
  })
}

variable "replicas" {
  description = "The ingress controller replica count"
  default     = 1
  type        = number
}

variable "routes" {
  description = "The ingress route configuration"
  default     = {}
  type = map(object({
    namespace = string
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
