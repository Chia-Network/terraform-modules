variable "custom_sg_rules" {
  description = "used to pass custom rules to the module"
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
