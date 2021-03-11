variable "zone_id" {
  description = "the zone to manage"
  type        = string
}

variable "record_name" {
  description = "the domain to create"
  type        = string
}

variable "record_value" {
  description = "the value for the record, must be an ipv4 address"
  type        = string
}

variable "record_type" {
  description = "dns entry type i.e. www or txt"
  type        = string
}

variable "proxied" {
  description = "proxy this record? default is false"
  type        = string
  default     = false
}
