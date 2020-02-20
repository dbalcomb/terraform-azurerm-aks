variable "name" {
  description = "The resource name"
  type        = string
}

variable "cluster" {
  description = "The cluster"
  type = object({
    id = string
  })
}

variable "monitor" {
  description = "The monitor information"
  default     = null
  type        = any
}

variable "service_principal" {
  description = "The service principal"
  type = object({
    id = string
  })
}

variable "enabled" {
  description = "Enable monitoring"
  default     = true
  type        = bool
}
