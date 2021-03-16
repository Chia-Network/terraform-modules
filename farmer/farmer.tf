#
# Ec2 Resources
#  * farmer
#


resource "aws_instance" "farmer" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.main_sg,var.admin_sg ]
  key_name               = var.key_name
  tags                   = merge(map("Name", "ChiaFarmer${count.index + 1}-${var.instance_name_tag}", "application", var.application_tag, "ref", var.ref,), var.extra_tags)

  provisioner "remote-exec" {
  inline = [
    "curl -1sLf 'https://repositories.timber.io/public/vector/cfg/setup/bash.deb.sh' | sudo -E bash",
    "sudo apt install -y vector",
  ]
  connection {
    type        = "ssh"
    host        = self.public_dns
    user        = var.ec2_user
    private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./vector.toml"
    destination = "/home/ubuntu/vector.toml"
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
    "sudo apt-get install -y git",
    "cd /home/ubuntu && git clone https://github.com/Chia-Network/chia-blockchain.git",
    "cd /home/ubuntu/chia-blockchain && git checkout ${var.ref}",
    "sudo cp /home/ubuntu/vector.toml /etc/vector/vector.toml",
    "mkdir /home/ubuntu/.chia",
    "sh install.sh",
    ". ./activate",
    "export CHIA_ROOT=/home/ubuntu/.chia",
    "chia init",
    "chia plots add -d /chia-plots",
    "chia configure --set-node-introducer ${var.introducer} --set-fullnode-port ${var.full_node_port} --set-log-level INFO",
    "echo \"${var.farmer_keys1}\" | chia keys add -",
    "echo \"${var.farmer_keys2}\" | chia keys add -",
    "chia init",
    "nohup chia start farmer &",
    "sudo systemctl enable vector",
    "sudo systemctl restart vector",
    "curl --header \"Content-Type: application/json\" --request POST --data \"{\"msg\":\"Farmer ${self.public_dns} for: ${{ steps.set_branch.outputs.ref }} deployed! Name Tag: ${{ steps.set_branch.outputs.instance_name_tag }}\"}\" https://bots.keybase.io/webhookbot/DKC7n8Dg8eCwZuVyT7O9_XlbM7c",
    "sleep 60",
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

  timeouts {
    create = "60m"
    update = "60m"
    delete = "180m"
  }

}
