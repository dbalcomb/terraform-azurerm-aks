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
