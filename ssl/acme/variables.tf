variable "email_address" {
  description = "the email address to use for ssl cert gen"
  type        = string
}

variable "domain" {
  description = "the domain for the cert"
  type        = string
}

variable "api_token" {
  description = "the token for the dns api"
  type        = string
}
