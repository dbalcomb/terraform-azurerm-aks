variable "name" {
  description = "The application name"
  type        = string
}

variable "consent" {
  description = "Grant admin consent with the Azure CLI"
  default     = false
  type        = bool
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
