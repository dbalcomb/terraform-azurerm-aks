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

variable "enabled" {
  description = "Enable ingress controller"
  default     = true
  type        = bool
}
