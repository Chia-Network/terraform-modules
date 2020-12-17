variable "vpc_name" {
  type = string
  description = "The VPC to deploy the service to"
  default = "chia-oregon"
}

variable "subnet_1_name" {
  type = string
  description = "The first of three subnets to deploy the service to"
  default = "chia1"
}

variable "subnet_2_name" {
  type = string
  description = "The second of three subnets to deploy the service to"
  default = "chia2"
}

variable "subnet_3_name" {
  type = string
  description = "The third of three subnets to deploy the service to"
  default = "chia3"
}

variable "security_group_name" {
  type = string
  description = "The name of the security group to create for kafka"
  default = "chia-centralized-metrics-kafka"
}

variable "application" {
  type        = string
  description = "this tag must be added so that the terraform-IAC role can manipulate this service"
  default = "chia"
}

variable "msk_name" {
  type        = string
  description = "The name of the actual MSK Cluster"
  default = "chia-logging-kafka"
}

variable "hosted_zone" {
  type = string
  description = "The route53 zone that the dns records will be added to"
  default = "chia-kafka.chiatechlab.com"
}

variable "broker_hostname" {
  type = string
  description = "The hostname that will be added to Route53 zone that contains kafka brokers"
  default = "metrics-kafka-brokers"
}
