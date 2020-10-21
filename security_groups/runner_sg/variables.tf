variable "bootstrap_sg" {
  description = "id of the bootstrap runners security group"
}

variable "vpc" {
  description = "ID of main VPC in region"
}

variable "application_tag" {
  description = "the instance tag to use"
  type        = string
  default     = "testnet"
}

variable "tags" {
  description = "Additional tags"
  type        = map
  default     = {}
}
