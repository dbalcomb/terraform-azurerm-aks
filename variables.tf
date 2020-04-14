variable "name" {
  description = "The Azure Kubernetes Service (AKS) name"
  type        = string
}

variable "location" {
  description = "The Azure Kubernetes Service (AKS) location"
  default     = "uksouth"
  type        = string
}

variable "registry" {
  description = "The container registry"
  default     = null
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

variable "cluster" {
  description = "The cluster configuration"
  default     = null
  type        = any
}

variable "network" {
  description = "The network configuration"
  default     = null
  type        = any
}

variable "monitor" {
  description = "The monitoring configuration"
  default     = null
  type        = any
}

variable "debug" {
  description = "Enable debugging"
  default     = false
  type        = bool
}
