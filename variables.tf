variable "name" {
  description = "The cluster name"
  type        = string
}

variable "location" {
  description = "The cluster location"
  default     = "uksouth"
  type        = string
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}

variable "subnets" {
  description = "The network subnet configuration"
  default = [
    { name = "primary" }
  ]
  type = list(map(any))
}

variable "pools" {
  description = "The cluster node pool configuration"
  default = {
    primary = {}
  }
  type = any
}

variable "registry" {
  description = "The container registry"
  type = object({
    id = string
    resource_group = object({
      id = string
    })
  })
}

variable "rbac" {
  description = "The role-based access control configuration"
  default     = null
  type        = any
}

variable "monitor" {
  description = "The monitoring configuration"
  default     = null
  type        = any
}

variable "dashboard" {
  description = "The dashboard configuration"
  default     = null
  type        = any
}

variable "ingress" {
  description = "The ingress configuration"
  default     = null
  type        = any
}

variable "kured" {
  description = "The kured configuration"
  default     = null
  type        = any
}

variable "kubernetes_version" {
  description = "The Kubernetes version"
  default     = null
  type        = string
}
