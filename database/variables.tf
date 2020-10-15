variable "allocated_storage_size" {
  description = "size of disk to provision"
  type        = string
}

variable "db_engine" {
  description = "db_engine"
  type        = string
}

variable "db_engine_version" {
  description = "db_engine_version"
  type        = string
}

variable "instance_class" {
  description = "instance_class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_user_name" {
  description = "database use name"
  type        = string
}

variable "db_password" {
  description = "database password"
  type        = string
}

variable "parameter_group_name" {
  description = "db paramater group name"
  type        = string
}

variable "db_name" {
  description = "database name"
  type        = string
}

variable "multi_az" {
  description = "does this db use multi az deployments?"
  type        = string
  default     = "true"
}

variable "publicly_accessible" {
  description = "should this instance be publicly accessible"
  type        = string
  default     = "false"
}

variable "security_groups" {
  description = "security groups to attach to the database"
}

variable "snapshot_id" {
  description = "snapshot id of previous db to restore"
}

variable "final_snapshot_id" {
  description = "final snapshot id when instance is destroyed"
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
