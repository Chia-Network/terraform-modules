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

    tags = {
    Name = "ChiaIntroducer-${var.instance_name_tag}-${count.index + 1}"
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
    source      = "./introducer-service"
    destination = "/home/ubuntu/chia-blockchain/introducer-service"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./start-service.sh"
    destination = "/home/ubuntu/chia-blockchain/start-service.sh"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./config"
    destination = "/home/ubuntu/.chia/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "export CHIA_ROOT=/home/ubuntu/.chia",
      "cd /home/ubuntu/chia-blockchain",
      "sh install.sh",
      ". ./activate",
      "cp -rf /home/ubuntu/.chia/* /home/ubuntu/.chia/config/",
      "cat /home/ubuntu/.chia/config/config.yaml",
      "export CHIA_ROOT=/home/ubuntu/.chia",
      "chia init",
      "nohup chia start introducer &",
      "sleep 60",
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

  timeouts {
    create = "30m"
    update = "30m"
    delete = "180m"
  }
}
