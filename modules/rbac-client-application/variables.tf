variable "name" {
  description = "The resource name"
  type        = string
}

variable "server" {
  description = "The server application"
  type = object({
    id = string
    scopes = list(object({
      id    = string
      value = string
    }))
  })
}
