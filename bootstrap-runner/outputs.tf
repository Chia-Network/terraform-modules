output "instance_ids" {
value       = [aws_instance.GithubRunner[0].id]
description = "The ids of the created github runner instances."
}
