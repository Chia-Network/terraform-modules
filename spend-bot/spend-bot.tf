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
  tags                   = merge(map("Name", "ChiaSpendBot${count.index + 1}-${var.instance_name_tag}", "application", var.application_tag, "ref", var.ref,), var.extra_tags)

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

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

  provisioner "file" {
    source      = "./spendbot-vars.sh"
    destination = "/home/ubuntu/spendbot-vars.sh"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./spendbot-install.sh"
    destination = "/home/ubuntu/spendbot-install.sh"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /home/ubuntu/spendbot-install.sh && sh /home/ubuntu/spendbot-install.sh",
      "python3 -m venv venv",
      "ln -s venv/bin/activate",
      "screen -S bot",
      ". ./activate",
      "pip install --upgrade pip",
      "pip install -e chia-blockchain/",
      "pip install -e .",
      "chia init",
      "chia keys generate",
      "python exchange/start_wallet_server.py",
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
