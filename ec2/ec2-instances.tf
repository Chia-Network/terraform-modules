#
# Ec2 Resources
#  * ec2
#


resource "aws_instance" "ec2" {
count                = var.instance_count
instance_type        = var.instance_type
iam_instance_profile = var.iam_instance_profile
ami                  = var.ami
security_groups      = var.security_groups
subnet_id            = var.subnet_id

  tags = {
  Name        = "${var.instance_name}-${count.index + 1}"
  application = var.application_name
  }
}
