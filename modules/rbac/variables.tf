variable "name" {
  description = "The resource name"
  type        = string
}

variable "consent" {
  description = "Grant admin consent with the Azure CLI"
  default     = false
  type        = bool
}

variable "groups" {
  description = "The group configuration"
  default     = null
  type        = any
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
