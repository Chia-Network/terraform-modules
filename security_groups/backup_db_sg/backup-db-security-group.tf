#
# Security Group Resources
#  * backup-db
#

resource "aws_security_group" "backup-db" {
  description = "Security Group for the backup db instances"
  vpc_id         = var.vpc


  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = var.security_group_ids
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "From VPN"
    from_port        = 5432
    to_port          = 5432
    protocol         = "TCP"
    cidr_blocks      = [var.vpn_cidr_block]
    ipv6_cidr_blocks = [var.vpn_ipv6_cidr_block]
  }

  tags = {
    Name        = "Backup DB Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
