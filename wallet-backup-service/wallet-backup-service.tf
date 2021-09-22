#
# Ec2 Resources
#  * BackupNode
#


resource "aws_instance" "BackupNode" {
  count                = var.instance_count
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  ami                  = var.ami
  security_groups      = var.security_groups
  subnet_id            = var.subnet_id
  key_name             = var.key_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "ChiaBackupService-${count.index + 1}"
    application = var.application_tag
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /home/ubuntu/chia-blockchain/ && sudo mkdir /home/ubuntu/chia-blockchain && sudo chown -R ubuntu:ubuntu /home/ubuntu/chia-blockchain",
      "sudo rm -rf /home/ubuntu/wallet-backup-service/ && sudo mkdir /home/ubuntu/wallet-backup-service && sudo chown -R ubuntu:ubuntu /home/ubuntu/wallet-backup-service",
    ]
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "../chia-blockchain"
    destination = "/home/ubuntu/"
    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = var.ec2_user
      private_key = file(var.ec2_key)
    }
  }

  provisioner "file" {
    source      = "../wallet-backup-service"
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
      "ln -s /home/ubuntu/chia-blockchain /home/ubuntu/wallet-backup-service/chia-blockchain",
      "export CHIA_ROOT=~/.chia",
      "cd /home/ubuntu/wallet-backup-service && sudo chmod a+x ./install_ubuntu.sh && sh ./install_ubuntu.sh",
      "sudo systemctl restart backup-service",
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
