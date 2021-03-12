variable "ref" {
default = ""
}

variable "k_size" {
default = "27"
}

variable "instance_count" {
default = "1"
}

variable "volume_size" {
default = "10"
}

variable "ec2_user" {
  description = "instance ec2 user"
  type        = string
}

variable "ec2_key" {
  description = "instance private key file"
  type        = string
}

variable "key_name" {
  description = "instance private key file aws name"
  type        = string
}

variable "ami" {
  description = "instance ami id"
  type        = string
}

variable "instance_name_tag" {
  description = "the name tag to apply to instances"
  type        = string
}

variable "instance_type" {
  description = "instance size/type"
  type        = string
  default     = "i3en.large"
}

variable "subnet_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}

variable "main_sg" {
  description = "Main Service Security Group for resources"
}

variable "admin_sg" {
  description = "admin sg"
}

variable "iam_instance_profile" {
   description = "IAM Instance Profile to use for Resource"
   type        = string
   default     = ""
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
