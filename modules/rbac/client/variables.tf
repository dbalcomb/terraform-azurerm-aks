variable "name" {
  description = "The application name"
  type        = string
}

variable "server" {
  description = "The server application"
  type        = any
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
