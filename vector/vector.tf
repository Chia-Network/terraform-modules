#
# Vector
#


resource "aws_instance" "vector" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.main_sg,var.admin_sg ]
  key_name               = var.key_name
  tags                   = "${merge(map("Name", "ChiaVector{count.index + 1}-${var.instance_name_tag}", "application", "${var.application_tag}", "branch", "${var.branch}",), var.extra_tags)}"

provisioner "remote-exec" {
  inline = [
    "curl -1sLf 'https://repositories.timber.io/public/vector/cfg/setup/bash.deb.sh' | sudo -E bash",
    "sudo apt install -y vector"
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
    destination = "/etc/vector/vector.toml"
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
    "sudo systemctl enable vector",
    "sudo systemctl restart vector",
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
