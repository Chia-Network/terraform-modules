#
# IAM Server Certificate
#  * cert
#

resource "aws_iam_server_certificate" "certificate" {
  name_prefix       = var.ssl_domain
  certificate_body  = var.ssl_cert
  private_key       = var.ssl_key
  certificate_chain = var.ssl_chain

  lifecycle {
    create_before_destroy = true
  }
}
