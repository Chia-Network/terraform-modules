#
# IAM Server Certificate
#  * cert
#

resource "aws_iam_server_certificate" "certificate" {
  name_prefix       = var.ssl_domain
  certificate_body  = var.ssl_cert
  private_key       = var.ssl_key

  # Some properties of an IAM Server Certificates cannot be updated while they
  # are in use. In order for Terraform to effectively manage a Certificate in
  # this situation, it is recommended you utilize the name_prefix attribute and
  # enable the create_before_destroy lifecycle block.
  lifecycle {
    create_before_destroy = true
  }
}
