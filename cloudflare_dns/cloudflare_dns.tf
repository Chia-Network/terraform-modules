#
# DNS Records
#  * DNS
#

resource "cloudflare_record" "dns" {
  zone_id  = var.zone_id
  name     = var.record_name
  value    = var.record_value
  type     = var.record_type
  proxied  = var.proxied
}
