variable "lb_name" {
  description = "the name to assign this load balancer"
}

variable "instance_ids" {
  description = "instance ids to join to elb"
}

variable "availability_zones" {
  description = "availability zones to join to elb"
}

variable "ssl_certificate" {
  description = "iam-server-certificate to add to the LB"
}
