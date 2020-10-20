#
# Security Group Resources
#  * backup-db
#

resource "aws_security_group" "sg-admin" {
  description = "Security Group for admin access"
  vpc_id         = var.vpc

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
    Name        = "Admin Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
