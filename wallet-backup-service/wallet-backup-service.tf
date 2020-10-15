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

  tags = {
  Name = "ChiaBackupService-${count.index + 1}"
  application = var.application_tag
  }

  lifecycle {
    create_before_destroy = true
  }
}
