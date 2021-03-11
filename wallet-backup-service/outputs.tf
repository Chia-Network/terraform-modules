output "instance_ids" {
value       = [aws_instance.BackupNode[0].id, aws_instance.BackupNode[1].id, aws_instance.BackupNode[2].id]
description = "The ids of the create ec2 instances."
}
