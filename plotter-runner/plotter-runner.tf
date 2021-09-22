#
# Ec2 Resources
#  * GithubRunner
#
#

resource "aws_instance" "PlotterRunner" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile
  ami                    = var.ami
  vpc_security_group_ids = [ var.security_group_main,var.admin_sg,var.bootstrap_sg ]
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name                   = "${ var.runner_name }-${count.index + 1}"
    application            = var.application_tag
  }

  provisioner "remote-exec" {
    inline = [
      "/home/ubuntu/actions-runner/config.sh --url https://github.com/Chia-Network --token ${ var.runner_token } --labels Plotter --runnergroup Plotter --unattended --replace",
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

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
  create_before_destroy = true

  }
}
