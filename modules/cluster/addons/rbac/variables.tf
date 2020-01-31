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

variable "administrators" {
  description = "The cluster administrator user email addresses"
  default     = []
  type        = list(string)
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
