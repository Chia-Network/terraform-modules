variable "instance_count" {
default = "1"
}

variable "volume_size" {
default = "100"
}

variable "runner_name" {
  description = "Github Runner Name"
  type = string
}

variable "ec2_user" {
  description = "instance ec2 user"
  type        = string
}

variable "ec2_key" {
  description = "instance private key file"
  type        = string
}

variable "instance_type" {
  description = "instance size/type"
  type = string
  default = "i3en.xlarge"
}

variable "bootstrap_sg" {
  description = "bootstrap group so these things can work on each other."
}

variable "ami" {
  description = "instance ami id"
  type = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to use for Resource"
  type = string
}

variable "subnet_id" {
  description = "The ID of the VPC that the instance security group belongs to"
}

variable "security_group_main" {
  description = "Main Service Security Group for resources"
}

variable "admin_sg" {
  description = "admin sg"
}

variable "runner_token" {
  description = "the github token for registering runners"
}

variable "application_tag" {
  description = "the instance tag to use"
  type        = string
  default     = "mainnet"
}

variable "key_name" {
  description = "ssh key for auth to this instance"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map
  default     = {}
}
