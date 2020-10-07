#
# Ec2 Resources
#  * GithubRunner
#
#

resource "aws_instance" "GithubRunner" {
  count                = var.instance_count
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  ami                  = var.ami
  security_groups      = var.security_groups
  subnet_id            = var.subnet_id

  tags = {
  Name = "${ var.runner_name }-${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = [
      "/home/ubuntu/actions-runner/config.sh --url https://github.com/Chia-Network --token ${ var.runner_token } --unattended --replace",
      "sudo systemctl enable github-runner",
      "sudo systemctl start github-runner",
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
