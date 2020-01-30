variable "name" {
  description = "The resource name"
  type        = string
}

variable "location" {
  description = "The resource location"
  type        = string
}

variable "address_space" {
  description = "The virtual network address space"
  default     = "10.0.0.0/8"
  type        = string
}

variable "dns_prefix" {
  description = "The public IP DNS prefix"
  type        = string
}

variable "subnets" {
  description = "The virtual network subnet configuration"
  default = [
    { name = "primary", bits = 8 }
  ]
  type = list(object({
    name = string
    bits = number
  }))
}

variable "service_principal" {
  description = "The service principal"
  type = object({
    id = string
  })
}
