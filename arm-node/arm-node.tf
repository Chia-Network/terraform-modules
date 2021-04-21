#
# Ec2 Resources
#  * arm node
#


resource "aws_instance" "arm-node" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.main_sg ]
  key_name               = var.key_name
  tags                   = merge(map("Name", "ChiaArmNode${count.index + 1}-${var.instance_name_tag}", "application", "${var.application_tag}", "ref", "${var.ref}",), var.extra_tags)

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
  create_before_destroy = true

  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "180m"
  }
}
