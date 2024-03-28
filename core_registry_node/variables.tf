variable "client_name" {
  type        = string
  description = "Name of the client, mostly used for bucket naming"
}

variable "ami_pattern" {
  description = "Pattern to match latest ami"
  type        = string
  default     = "Chia_Ubuntu_Base*"
}

variable "ami_arch" {
  type        = string
  description = "AMI Architecture - x86_64 or arm64"
  default     = "arm64"
}

variable "node_vpc" {
  type        = string
  description = "VPC to use in node creation, security groups, and anything else related"
}

variable "node_subnet" {
  type        = string
  description = "Subnet to use in EC2 creation"
}

variable "chia_node_port" {
  type        = string
  description = "Chia Full Node port"
  default     = "8444"
}

variable "user_data" {
  type        = string
  description = "Script that runs when instance is created"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance size and type"
  default     = "m7g.large"
}

variable "volume_size" {
  type        = string
  description = "Root volume size for EC2"
  default     = "300"
}

variable "cf_zone" {
  type        = string
  description = "Cloudflare zone where we will create the A record for this instance"
}

variable "cf_app_proxied" {
  type        = "bool"
  description = "Proxy through Cloudflare, true or false"
  default     = "true"
}

variable "cf_datalayer_proxied" {
  type        = "bool"
  description = "Proxy through Cloudflare, true or false"
  default     = "true"
}

variable "app_domain" {
  type        = string
  description = "Domain where the application will be served from"
}

variable "data_domain" {
  type        = string
  description = "Domain where datalayer will be served from"
}

variable "key_name" {
  type        = string
  description = "SSH keypair"
}

variable "secgroups" {
  type        = list(string)
  description = "List of security groups to apply to the EC2 instance"
}

variable "eip" {
  type        = bool
  description = "True or false to create an elastic IP for the resource"
  default     = "true"
}
