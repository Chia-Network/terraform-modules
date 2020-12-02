#
# Ec2 Resources
#  * introducer
#


  resource "aws_instance" "introducer" {
    count                  = var.instance_count
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [ var.main_sg,var.admin_sg ]
    key_name               = var.key_name
    #iam_instance_profile = var.instance-role+

    tags = {
    Name = "ChiaIntroducer-${count.index + 1}"
    application = var.application_tag
    }

    provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /home/ubuntu/chia-blockchain/ && sudo mkdir /home/ubuntu/chia-blockchain && sudo chown -R ubuntu:ubuntu /home/ubuntu/chia-blockchain",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./chia-blockchain"
    destination = "/home/ubuntu/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = ".introducer-service"
    destination = "/home/ubuntu/chia-blockchain/introducer-service"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ubuntu/chia-blockchain/introducer-service  /etc/systemd/system/introducer-service.service",
      "export CHIA_ROOT=~/.chia",
      "cd /home/ubuntu/chia-blockchain",
      "sh install.sh",
      ". ./activate",
      "chia init",
      "chia keys generate",
      "chia init",
      "sudo systemctl enable introducer-service && sudo systemctl start introducer-service",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
  create_before_destroy = true

  }
}
