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

variable "vpn_ipv6_cidr_block" {
  description = "vpn_ipv6_cidr_block"
  type        = string
}

variable "vpn_cidr_block" {
  description = "vpn_cidr_block"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map
  default     = {}
}
