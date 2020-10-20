#
# Ec2 Resources
#  * GithubRunner
#
#

resource "aws_instance" "BootstrapRunner" {
  count                = var.instance_count
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  ami                  = var.ami
  security_groups      = var.security_groups
  subnet_id            = var.subnet_id
  key_name             = var.key_name

  tags = {
  Name = "${ var.runner_name }-${count.index + 1}"
  application           = var.application_tag
  }

  provisioner "local-exec" {
    command = "aws s3 cp s3://chia-terraform/networkchianet.pem/networkchianet.pem && chmod 0400 networkchianet.pem"

  }

  provisioner "remote-exec" {
    inline = [
      "/home/ubuntu/actions-runner/config.sh --url https://github.com/Chia-Network --token ${ var.runner_token } --labels Bootstrap --runnergroup BootstrapRunner --unattended --replace",
      "cd /home/ubuntu/actions-runner && sudo ./svc.sh install",
      "cd /home/ubuntu/actions-runner && sudo ./svc.sh start",
      #"sudo su && hostnamectl set-hostname ${ var.runner_name }-${count.index + 1}",
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
