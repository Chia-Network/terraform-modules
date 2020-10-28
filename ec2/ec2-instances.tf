#
# Ec2 Resources
#  * ec2
#


resource "aws_instance" "ec2" {
count                  = var.instance_count
instance_type          = var.instance_type
iam_instance_profile   = var.iam_instance_profile
ami                    = var.ami
vpc_security_group_ids = [ var.security_group_main,var.admin_sg ]
subnet_id              = var.subnet_id
key_name               = var.key_name

  tags = {
  Name                 = "${var.instance_name}-${count.index + 1}"
  application          = var.application_tag
  }

  root_block_device {
    volume_size = var.volume_size
  }
}
