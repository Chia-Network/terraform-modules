#
# ACME SSL Certificate
#  * private_key, reg, certificate
#

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  account_key_pem            = acme_registration.reg.account_key_pem
  common_name                = var.domain
  #subject_alternative_names = ["www2.example.com"]

  dns_challenge {
    provider = "cloudflare"

    config   = {
    CF_API_EMAIL     = var.email_address
    CF_DNS_API_TOKEN = var.api_token
    }
  }
}
