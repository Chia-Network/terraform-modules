#
# Security Group Resources
#  * sg-bootstrap
#

resource "aws_security_group" "sg-bootstrap" {
  description   = "Default bootstrap runner Security Profile"
  vpc_id        = var.vpc

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH from VPN"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_cidr_block]
    ipv6_cidr_blocks = [var.vpn_ipv6_cidr_block]
  }

  ingress {
    description = "Allow self"
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = {
    Name        = "Bootstrap Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
