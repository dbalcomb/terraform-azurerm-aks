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

variable "enabled" {
  description = "Enable ingress controller"
  default     = true
  type        = bool
}
