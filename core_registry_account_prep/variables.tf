variable "node_vpc" {
  type        = string
  description = "VPC to use in node creation, security groups, and anything else related"
}

variable "testnet_fullnode_port" {
  type        = string
  description = "Chia Full Node port"
  default     = "58444"
}

variable "mainnet_fullnode_port" {
  type        = string
  description = "Chia Full Node port"
  default     = "8444"
}
