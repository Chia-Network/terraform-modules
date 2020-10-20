variable "policy_name" {
  description = "the policy name to create"
  type        = string
  default     = "test"
}

variable "policy_file" {
  description = "path to the policy file to create with"
  type        = string
}

variable "role_name" {
  description = "the role name to create"
  type        = string
  default     = "test"
}

variable "role_file" {
  description = "path to the role file to create with"
  type        = string
  default     = "test"
}

variable "profile_name" {
  description = "the profile name to create"
  type        = string
  default     = "test"
}
