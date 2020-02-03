variable "config" {
  description = "The group configuration"
  default     = {}
  type = map(object({
    label   = string
    members = list(string)
    enabled = bool
  }))
}
