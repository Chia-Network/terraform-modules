#
# Security Group Resources
#  * sg-runner
#

resource "aws_security_group" "sg-runner" {
  description   = "Default runner Security Profile"
  vpc_id        = var.vpc

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ssh from the bootstrap runner"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = var.bootstrap_security_group_id
  }

  ingress {
    description      = "SSH from VPN"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_cidr_block]
    ipv6_cidr_blocks = [var.vpn_ipv6_cidr_block]
  }

  ingress {
    description      = lookup(var.custom_sg_rules,user1_desc)
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [lookup(var.custom_sg_rules,user1_ipv4_cidr)]
    ipv6_cidr_blocks = [lookup(var.custom_sg_rules,user1_ipv6_cidr)]
  }

  ingress {
    description      = lookup(var.custom_sg_rules,user2_desc
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = [lookup(var.custom_sg_rules,user2_ipv6_cidr)]
  }

  ingress {
    description      = lookup(var.custom_sg_rules,user3_desc)
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks       = [lookup(var.custom_sg_rules,user3_ipv4_cidr)]
  }

  ingress {
    description       = lookup(var.custom_sg_rules,user4_desc)
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [lookup(var.custom_sg_rules,user3_ipv4_cidr)]
  }

  tags = {
    Name        = "Runner Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
