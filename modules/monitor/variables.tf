variable "name" {
  description = "The resource name"
  type        = string
}

variable "location" {
  description = "The resource location"
  type        = string
}

variable "retention" {
  description = "The log retention period in days"
  default     = 30
  type        = number
}

variable "enabled" {
  description = "Enable monitoring"
  default     = true
  type        = bool
}
