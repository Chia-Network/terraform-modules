variable "image_copy_name" {
  description = "Name of AMI to create with the copy"
  type        = string
}

variable "source_ami_id" {
  description = "amd if for copy source typically the one create by the instance to ami module"
  type        = string
}

variable "source_ami_region"{
  description = "this will almost always be us-west-2"
  type        = string
}
