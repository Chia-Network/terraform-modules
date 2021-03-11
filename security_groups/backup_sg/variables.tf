variable "vpn_cidr_block" {
  description = "cidr block of the vpn server"
  type        = string
}

variable "vpn_ipv6_cidr_block" {
  description = "ipv6 cidr block of the vpn server"
  type        = string
}

variable "vpc" {
  description = "ID of main VPC in region"
}

variable "application_tag" {
  description = "the instance tag to use"
  type        = string
  default     = "testnet"
}
