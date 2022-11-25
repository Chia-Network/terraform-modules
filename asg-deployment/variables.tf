variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_name_filter" {
  description = "Name patter to filter VPC on"
  type        = string
  default     = "chia-main*"
}

variable "subnet_name_patterns" {
  description = "Name patterns to match subnets with"
  type        = list(string)
  default     = ["chia-main*"]
}

variable "security_groups" {
  description = "Security Groups to add to the instance. Will match wildcards."
  type        = list(string)
  default     = []
}

variable "ami_pattern" {
  description = "Pattern to match latest ami"
  type        = string
  default     = "Chia_Ubuntu_Base*"
}

variable "ami_arch" {
  description = "Arch to match for AMI"
  type        = string
  default     = "x86_64"
}

variable "instance_count" {
  description = "Number of instances in the auto scaling group"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Private key to use for the instances"
  type        = string
  default     = "UserifyOrCAOnly"
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to use for Resource"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "user data to pass to the node on startup"
  type        = string
  default     = ""
}

variable "volume_type" {
  description = "Type of EBS Volume"
  type        = string
  default     = "gp3"
}

variable "volume_size" {
  description = "Size of the EBS volume"
  type = number
  default = 100
}

variable "volume_iops" {
  description = "Number of IOPS for the EBS volume. 3000 is the base included value"
  type = number
  default = 3000
}

variable "volume_throughput" {
  description = "Throughput for the volume. 125 is the base included value"
  type = number
  default = 125
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before failing health checks mark the instance as unhealthy"
  type        = number
  default     = 900
}

variable "default_instance_warmup" {
  description = "Default warmup time for new instances"
  type        = number
  default     = 600
}

// Spot Mix Settings

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  type        = string
  default     = "1"
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity."
  type        = number
  default     = 100
}

variable "spot_max_price" {
  type        = string
  description = "max price to pay for spot instances. Default is empty string, which means use the on demand price"
  default     = ""
}

variable "instance_type" {
  description = "The preferred instance type"
  type        = string
  default     = "c5.large"
}

variable "spot_allocation_strategy" {
  description = "Spot allocation strategy"
  type        = string
  default     = "price-capacity-optimized"
}

variable "spot_instance_pools" {
  description = "Number of spot instance pools. Only valid when spot_allocation_strategy is lowest-price"
  type        = number
  default     = 4
}

// PORTS

variable "lb_traffic_port" {
  description = "Traffic port for LB routing"
  type        = number
  default     = 8444
}

variable "lb_protocol" {
  description = "Protocol for traffic on the LB"
  type        = string
  default     = "TCP"
}

variable "lb_health_check_port" {
  description = "Port for checking health of the targets"
  type        = number
  default     = 8444
}

variable "lb_health_check_protocol" {
  description = "Protocol for LB health check"
  type        = string
  default     = "TCP"
}


// TAGS

variable "application_tag" {
  description = "The application. chia-blockchain, faucet, etc"
  type        = string
  default     = "chia-blockchain"
}

variable "component_tag" {
  description = "the component of the application. Ex dns-introducer, fullnode, farmer, etc"
  type        = string
}

variable "network_tag" {
  description = "Network (mainnet, testnet10, etc)"
  type        = string
}

variable "ref_tag" {
  description = "The git ref that is deployed to this introducer"
  type        = string
}

variable "group_tag" {
  description = "The group tag can be used when more context to the resource needs to be added to distinguish between introducer that otherwise have identical application, network, component, and ref tags."
  type        = string
  default     = "default"
}
