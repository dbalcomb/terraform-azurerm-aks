variable "name" {
  description = "The ingress name"
  type        = string
}

variable "replicas" {
  description = "The ingress replica count"
  default     = 1
  type        = number
}

variable "ip_address" {
  description = "The ingress load balancer IP address"
  type        = string
}

variable "resource_group_name" {
  description = "The ingress load balancer resource group name"
  type        = string
}

variable "enabled" {
  description = "Enable ingress"
  default     = true
  type        = bool
}
