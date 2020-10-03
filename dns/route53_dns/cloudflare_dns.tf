#
# DNS Records
#  * DNS
#

resource "aws_route53_record" "dns" {
  zone_id  = var.zone_id
  name     = var.record_name
  type     = var.record_type
  ttl      = var.ttl
  records  = var.records
}
