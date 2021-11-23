variable "prometheus" {
  description = "The prometheus data collection settings"
  default     = null
  type        = any
}

variable "log" {
  description = "The log data collection settings"
  default     = null
  type        = any
}
