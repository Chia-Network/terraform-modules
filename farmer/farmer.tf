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
  tags                   = "${merge(map("Name", "ChiaFarmer${count.index + 1}-${var.instance_name_tag}", "application", "${var.application_tag}", "branch", "${var.branch}",), var.extra_tags)}"

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /home/ubuntu/chia-blockchain/ && sudo mkdir /home/ubuntu/chia-blockchain && sudo chown -R ubuntu:ubuntu /home/ubuntu/chia-blockchain && mkdir /home/ubuntu/.chia && mkdir /home/ubuntu/.chia/config",
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
    "sudo cp /home/ubuntu/vector.toml /etc/vector/vector.toml",
    "mkdir /home/ubuntu/.chia",
    "cd /home/ubuntu/chia-blockchain",
    "sh install.sh",
    ". ./activate",
    "export CHIA_ROOT=/home/ubuntu/.chia",
    "chia init",
    "chia plots add -d /chia-plots",
    "chia configure --set-node-introducer ${var.introducer} --set-fullnode-port ${var.full_node_port} --set-log-level INFO",
    "chia keys add -m \"${var.farmer_keys1}\"",
    "chia keys add -m \"${var.farmer_keys2}\"",
    "chia init",
    "nohup chia start farmer &",
    "sudo systemctl enable vector",
    "sudo systemctl restart vector",
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
