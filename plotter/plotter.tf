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



  provisioner "file" {
    source      = "./chiapos"
    destination = "/home/ubuntu/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "./test/plot-resources.py"
    destination = "/home/ubuntu/chiapos/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
    "cd ./chiapos",
    "ls /dev | grep nvme",
    "ll",
    "mkfs.ext4 /dev/nvme0n1 && mkdir /mnt/plots && mount /dev/nvme0n1 /mnt/plots",
    "mkdir build && cd build && cmake ../ && cmake --build . -- -j 6",
    "chmod a+x plot-resources.py",
    "pip install psutil",
    "nohup python ./plot-resources.py 32 &",
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
