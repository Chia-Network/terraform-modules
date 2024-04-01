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

variable "key_name" {
  type        = string
  description = "Name for AWS Key Pair to use with EC2 instance"
  default     = "no-access-keypair"
}

variable "public_key" {
  type        = string
  description = "Public key to use with the key_name for SSH access to EC2 instance"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhTYTuiMjbGo+v6VWzFtBW2vyzZWs1AXpfZKoqLd3ut"
}
