variable "group" {
  type        = string
  description = "The name of group"
}

variable "users" {
  type = list(object({
    Name  = string
    Group = string
    Role  = string
  }))
  description = "The list of User data"
}