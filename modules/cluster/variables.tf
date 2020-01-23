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

variable "log_analytics" {
  description = "The Log Analytics configuration"
  type = object({
    workspace = object({
      id = string
    })
  })
}

variable "dns_prefix" {
  description = "The cluster DNS prefix"
  type        = string
}
