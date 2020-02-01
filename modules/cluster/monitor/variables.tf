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

variable "service_principal" {
  description = "The service principal"
  type = object({
    id = string
  })
}
