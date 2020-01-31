variable "name" {
  description = "The application name"
  type        = string
}

variable "server" {
  description = "The server application"
  type        = map(any)
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
