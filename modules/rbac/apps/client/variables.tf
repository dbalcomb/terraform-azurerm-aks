variable "name" {
  description = "The application name"
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
