#
# AWS ACM SSL Certificate
#  * cert, validation
#

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

module "dns" {
  source            = "git@github.com:Chia-Network/terraform-modules.git//cloudflare_dns"
  zone_id           = var.zone_id
  record_name       = aws_acm_certificate.cert.domain_validation_options.resource_record_name
  record_value      = aws_acm_certificate.cert.domain_validation_options.resource_record_value
  record_type       = aws_acm_certificate.cert.domain_validation_options.resource_record_type
  providers         = {
      cloudflare = cloudflare
    }
}
