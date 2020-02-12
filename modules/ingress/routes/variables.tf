variable "controller" {
  description = "The controller information"
  type = object({
    name      = string
    namespace = string
  })
}

variable "routes" {
  description = "The route configuration"
  type = map(object({
    rules = list(object({
      host = string
      paths = list(object({
        path                 = string
        backend_service_name = string
        backend_service_port = number
      }))
    }))
  }))
}

variable "enabled" {
  description = "Enable routes"
  default     = true
  type        = bool
}
