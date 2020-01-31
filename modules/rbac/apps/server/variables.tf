variable "name" {
  description = "The application name"
  type        = string
}

variable "consent" {
  description = "Grant admin consent with the Azure CLI"
  default     = false
  type        = bool
}
