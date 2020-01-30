variable "name" {
  description = "The Service Principal App Registration name"
  type        = string
}

variable "role_assignments" {
  description = "The role assignments"
  default     = {}
  type = map(object({
    scope = string
    role  = string
  }))
}
