variable "name" {
  description = "The resource name"
  type        = string
}

variable "consent" {
  description = "Grant admin consent with the Azure CLI"
  default     = false
  type        = bool
}