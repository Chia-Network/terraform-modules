output "instance_ids" {
value       = [aws_instance.ec2[0].id]
description = "The ids of the create ec2 instances."
}
