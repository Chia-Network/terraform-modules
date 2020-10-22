#
# Ec2 Resources
#  * timelord
#


resource "aws_instance" "timelord" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.security_group_main,var.admin_sg ]
  key_name               = var.key_name
  #iam_instance_profile = var.instance-role+

  tags = {
  Name = "ChiaTimelord-${count.index + 1}"
  application = var.application_tag
  }

  provisioner "remote-exec" {
    inline = [
      "export CHIA_ROOT=~/.chia",
      "cd /home/ubuntu/chia-blockchain",
      ". ./activate",
      "sh ./install-timelord.sh",
      "chia init",
      "chia keys generate",
      "chia init",
      "chia start timelord",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  lifecycle {
  create_before_destroy = true

  }
}
