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

variable "debug" {
  description = "Enable debugging"
  default     = false
  type        = bool
}
