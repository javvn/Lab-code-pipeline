variable "ec2_control" {
  type        = bool
  default     = false
  description = "ec2 instance state control"
}

variable "ec2_state" {
  type        = string
  default     = "stopped"
  description = "allows managing an instance power state"
}
