#
# Ec2 Resources
#  * spend-bot
#


resource "aws_instance" "spend-bot" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.main_sg,var.admin_sg ]
  key_name               = var.key_name
  tags                   = merge(map("Name", "ChiaMainNode${count.index + 1}-${var.instance_name_tag}", "application", "${var.application_tag}", "ref", "${var.ref}",), var.extra_tags)

  provisioner "file" {
    source      = "./report.sh"
    destination = "/home/ubuntu/report.sh"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
  inline = [
    "sudo rm -rf /home/ubuntu/.chia && sudo mkdir /home/ubuntu/.chia && sudo chown -R ubuntu:ubuntu /home/ubuntu/.chia",
  ]
  connection {
    type        = "ssh"
    host        = self.public_dns
    user        = var.ec2_user
    private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      git clone git@github.com:Chia-Network/Chia-Exchange.git
      git checkout spend_bot
      git submodule update --init
      cd chia-blockchain
      git checkout testnet_6
      cd ..
      python3 -m venv venv
      ln -s venv/bin/activate
      . ./activate
      pip install --upgrade pip
      pip install -e chia-blockchain/
      pip install -e .
      python exchange/start_wallet_server.py
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