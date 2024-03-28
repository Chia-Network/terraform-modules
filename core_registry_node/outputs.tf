output "private_ip_address" {
  value       = aws_instance.core-registry.private_ip
  description = "Private IP of the EC2 instance"
}

output "elastic_ip_address" {
  value       = local.ip_address
  description = "Public IP (EIP or ephemeral) of the EC2 instance"
}
