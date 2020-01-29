variable "name" {
  description = "The resource name"
  type        = string
}

variable "location" {
  description = "The resource location"
  type        = string
}

variable "sku" {
  description = "The SKU name"
  default     = "Basic"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix"
  type        = string
}
