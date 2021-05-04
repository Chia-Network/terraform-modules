#
# Ec2 Resources
#  * faucet
#

resource "aws_instance" "faucet-node" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.main_sg, var.admin_sg]
  key_name               = var.key_name
  tags                   = merge(map("Name", "ChiaFaucetNode${count.index + 1}-${var.instance_name_tag}", "application", var.application_tag, "chia_ref", var.chia_ref, ), var.extra_tags)

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
      "rm -rf /home/ubuntu/chia-blockchain",
      "echo \"cloning blockchain and checking out ${var.chia_ref}\"",
      "cd /home/ubuntu && git clone https://github.com/Chia-Network/chia-blockchain.git",
      "cd /home/ubuntu/chia-blockchain && git checkout ${var.chia_ref}",
      "mkdir /home/ubuntu/.chia",
      "sh install.sh",
      ". ./activate",
      "export CHIA_ROOT=/home/ubuntu/.chia",
      "chia init",
      "chia configure --set-node-introducer ${var.introducer} --set-fullnode-port ${var.full_node_port} --set-log-level INFO",
      "nohup chia start wallet &",
      //"sudo chmod +x /home/ubuntu/report.sh && sh /home/ubuntu/report.sh ${self.public_dns} ${var.chia_ref} ${var.instance_name_tag}",
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
