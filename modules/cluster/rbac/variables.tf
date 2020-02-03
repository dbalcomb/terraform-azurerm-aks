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

variable "groups" {
  description = "The group information"
  type = map(object({
    id = string
  }))
}

variable "enabled" {
  description = "Enable role-based access control"
  default     = true
  type        = bool
}
