variable "account_id" {
  type        = string
  default     = "369463259913"
  description = "The account id of AWS"
}
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