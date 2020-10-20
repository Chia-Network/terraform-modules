#
# Security Group Resources
#  * backup-db
#

resource "aws_security_group" "sg-admin" {
  description = "Security Group for admin access"
  vpc_id         = var.vpc

  ingress {
    description      = var.desc-1
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4-1]
    ipv6_cidr_blocks = [var.ipv6-1]
  }

  ingress {
    description      = var.desc-2
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = [var.ipv6-2]
  }

  ingress {
    description      = var.desc-3
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks       = [var.ipv4-3]
  }

  ingress {
    description       = var.desc-4
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [var.ipv4-4]
  }

  tags = {
    Name        = "Admin Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
