variable "instance_count" {
default = "1"
}

variable "volume_size" {
default = "10"
}

variable "instance_type" {
  description = "instance size/type"
  type        = string
  default     = "t3.micro"
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to use for Resource"
  type        = string
  default     = ""
}

variable "ami" {
  description = "instance ami id"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}

variable "security_group_main" {
  description = "Main Service Security Group for resources"
}

variable "admin_sg" {
  description = "admin sg"
}

variable "availability_zones" {
  description = "Availability Zones the instances are launched in. If not set, will be launched in the first AZ of the region"
  default     = {}
}

variable "instance_name" {
  description = "Name of the ec2 instance to create"
}

variable "application_tag" {
  description = "the instance tag to use"
  type        = string
  default     = "testnet"
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
