variable "vpc_id" {
  description = "The VPC ID deploying to"
  type        = string
}

variable "ami_pattern" {
  description = "Pattern to match latest ami"
  type        = string
  default     = "Chia_Ubuntu_Base*"
}

variable "instance_count" {
  default = "1"
}

variable "instance_type" {
  description = "instance size/type"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}

variable "security_groups" {
  description = "SGs to add to the instance"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "instance private key file aws name"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to use for Resource"
  type        = string
  default     = ""
}

variable "ebs_optimized" {
  type    = bool
  default = null
}

variable "application_tag" {
  description = "The application. chia-blockchain, faucet, etc"
  type        = string
}

variable "component_tag" {
  description = "the component of the application. Ex dns-introducer, node, farmer, etc"
  type        = string
}

variable "network_tag" {
  description = "Network (mainnet, testnet, etc)"
  type        = string
}

variable "ref_tag" {
  description = "The git ref that is deployed to this node"
  type        = string
  default     = ""
}

variable "group_tag" {
  description = "The group tag can be used when more context to the resource needs to be added to distinguish between nodes that otherwise have identical application, network, component, and ref tags."
  type        = string
  default     = "default"
}

# LB ref tag is specified separate from the other ref so that for the main network, we can specify separately from
# the actual ref so we aren't constantly destroying/recreating load balancers
variable "lb_ref_tag" {
  description = "The ref tag to use in the `name` of load balancer resources"
  type        = string
  default     = ""
}

variable "deployset_tag" {
  description = "If set, this will be added to name/tags and indicates which set this is part of. Useful for things like nodes, where multiple sets of many nodes are deployed with separate LBs"
  type        = string
  default     = "a"
}

variable "extra_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "volume_size" {
  default = "100"
}

variable "lb_enabled" {
  default = true
  type    = bool
}

variable "lb_port" {
  default = 8444
  type    = number
}

variable "lb_protocol" {
  default = "TCP"
  type    = string
}

variable "lb_ipv6" {
  default     = true
  description = "Should ipv6 be enabled for the LB"
  type        = bool
}

variable "set_cloudflare_dns" {
  type    = bool
  default = false
}

variable "set_cloudflare_node_dns" {
  type        = bool
  description = "Sets a dns entry for the first node that was deployed. Mostly useful for testnet introducers"
  default     = false
}

variable "cloudflare_zone" {
  description = "Name of the zone to add the records to in cloudflare"
  type        = string
  default     = ""
}

variable "dns_ttl" {
  type    = number
  default = 300
}

variable "dns_name_prefix" {
  description = "Prefix for the dns name that will be generated for the load balancers. Will have the deployset added"
  type        = string
  default     = ""
}
