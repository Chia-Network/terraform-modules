#
# Ami Copy
#  * ami_copy
#

resource "aws_ami_copy" "ami_copy" {
  name              = var.image_copy_name
  description       = "Copy an ami"
  source_ami_id     = var.source_ami_id
  source_ami_region = var.source_ami_region

  tags = {
    Name = var.image_copy_name
  }
}
