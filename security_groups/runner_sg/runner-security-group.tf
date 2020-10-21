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
    description      = "from the bootstrap runner"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = var.bootstrap_sg
  }

  tags = {
    Name        = "Runner Security Group"
    application = var.application_tag
  }

  lifecycle {
  create_before_destroy = true
  }
}
