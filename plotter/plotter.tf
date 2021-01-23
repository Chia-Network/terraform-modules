#
# Ec2 Resources
#  * plotter
#


resource "aws_instance" "plotter" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.main_sg,var.admin_sg ]
  key_name               = var.key_name

  tags = {
  Name = "ChiaPlotter-${var.instance_name_tag}-${count.index + 1}"
  application = var.application_tag
  }

  provisioner "remote-exec" {
    inline = [
    "sudo mkfs.ext4 /dev/nvme1n1 && sudo mkdir /mnt/nvme && sudo mount /dev/nvme1n1 /mnt/nvme && sudo chown -R ubuntu:ubuntu /mnt/nvme",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./chiapos"
    destination = "/mnt/nvme/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
    "sudo mkdir /mnt/nvme/chiapos/plots && sudo mkdir /mnt/nvme/chiapos/plots/temp && sudo mkdir /mnt/nvme/chiapos/plots/final && sudo chown -R ubuntu:ubuntu /mnt/nvme",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./chia-plotter/plot.sh"
    destination = "/mnt/nvme/chiapos/plot.sh"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
    "sudo chmod -R 777 /mnt/nvme",
    "cd /mnt/nvme/",
    "mkdir build && cd build && cmake ../ && cmake --build . -- -j 6",
    "sudo chmod a+x /mnt/nvme/plot.sh",
    "touch ./plotter.log",
    "nohup sh /mnt/nvme/plot.sh ${var.k_size} > ./plotter.log &",
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
}
