variable "label" {
  description = "The group label"
  type        = string
}

variable "members" {
  description = "The group members"
  default     = []
  type        = list(string)
}
