variable "desc-1" {
  description = "admin user 1 desccription"
}

variable "desc-2" {
  description = "admin user 2 desccription"
}

variable "desc-3" {
  description = "admin user 3 desccription"
}

variable "desc-4" {
  description = "admin user 4 desccription"
}

variable "ipv4-1" {
  description = "ipv4 cidr blocks admin 1"
}

variable "ipv6-1" {
  description = "ipv6 cidr blocks admin 1"
}

variable "ipv6-2" {
  description = "ipv6 cidr blocks admin 2"
}

variable "ipv4-3" {
  description = "ipv4 cidr blocks admin 3"
}

variable "ipv4-4" {
  description = "ipv4 cidr blocks admin 4"
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
