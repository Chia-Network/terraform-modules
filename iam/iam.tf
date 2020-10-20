#
# Iam Policy for Chia Cloud Platform
#  *policy, role, attachment, profile
#
resource "null_resource" "local_exec" {
  provisioner "local-exec" {
    command = "aws s3 cp ${var.policy_path} ./ && aws s3 cp ${var.role_assume_policy_path} "
  }

}


resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "policy for ${var.policy_name}"
  policy      = file("${path.root}/${var.policy_file}")

  lifecycle {
  create_before_destroy = true
  }
}

#
# Iam Roles for ec2-instances
#  * runner_role
#

resource "aws_iam_role" "role" {
  name                    = var.role_assume_policy_name
  description             = "policy for ${var.role_assume_policy_name}"
  assume_role_policy      = file("${path.root}/${var.role_assume_policy_file}")
  path                    = "/"
  force_detach_policies   = "true"
  lifecycle {
  create_before_destroy = true
  }
}

#
# Iam role and policy attachments
#

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn

  lifecycle {
  create_before_destroy = true
  }
}

#
# Iam instance profiles
#

resource "aws_iam_instance_profile" "profile" {
  name = var.profile_name
  role = aws_iam_role.role.name
  lifecycle {
  create_before_destroy = true
  }
}
