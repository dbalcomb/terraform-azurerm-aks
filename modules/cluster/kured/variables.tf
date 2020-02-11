variable "name" {
  description = "The resource name"
  type        = string
}

variable "enabled" {
  description = "Enable kured"
  default     = true
  type        = bool
}
