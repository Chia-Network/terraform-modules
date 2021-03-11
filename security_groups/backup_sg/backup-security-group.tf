#
# Security Group Resources
#  * sg-dev
#

resource "aws_security_group" "sg-backup" {
  description   = "Default wallet backup instance Security Profile"
  vpc_id        = var.vpc

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8444
    to_port          = 8444
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

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

  tags = {
    Name = "Wallet backup instances security group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
