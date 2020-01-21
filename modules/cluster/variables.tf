variable "name" {
  description = "The cluster name"
  type        = string
}

variable "location" {
  description = "The cluster location"
  type        = string
}

variable "service_principal" {
  description = "The cluster service principal"
  type = object({
    id     = string
    secret = string
  })
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}
