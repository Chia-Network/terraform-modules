variable "zone_id" {
  description = "the zone to manage"
  type        = string
}

variable "record_name" {
  description = "the domain to create"
  type        = string
}

variable "records" {
  description = "the destination records"
}

variable "record_type" {
  description = "dns entry type i.e. www or txt"
  type        = string
}

variable "ttl" {
  description = "records time to live"
  type        = string
  default     = 300
}
