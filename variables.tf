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

variable "retention" {
  description = "The Log Analytics retention period in days"
  default     = 30
  type        = number
}

variable "subnets" {
  description = "The network subnet configuration"
  default = [
    { name = "primary" }
  ]
  type = list(map(any))
}

variable "pools" {
  description = "The cluster node pool configuration"
  default = {
    primary = {}
  }
  type = map(any)
}
