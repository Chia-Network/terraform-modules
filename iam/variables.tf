variable "policy_name" {
  description = "the policy name to create"
  type        = string
  default     = "test"
}

variable "policy_file" {
  description = "path to the policy file to create with"
  type        = string
}

variable "role_assume_policy_name" {
  description = "the role name to create"
  type        = string
  default     = "test"
}

variable "role_assume_policy_file" {
  description = "path to the role file to create with"
  type        = string
  default     = "test"
}

variable "profile_name" {
  description = "the profile name to create"
  type        = string
  default     = "test"
}

variable "policy_path" {
  description = "the path to the policy file"
  type        = string
}

variable "role_assume_policy_path" {
  description = "the path to the role assume policy file"
  type        = string
}
