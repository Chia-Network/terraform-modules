variable "instance_count" {
default = "1"
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
  default = "t3.medium"
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

variable "security_groups" {
  description = "Security Group for resources"
}

variable "runner_token" {
  description = "the github token for registering runners"
}

variable "tags" {
  description = "Additional tags"
  type        = map
  default     = {}
}
