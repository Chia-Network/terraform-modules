output "public_dns" {
  value       = aws_instance.chianode.*.public_dns
  description = "the public dns for this instance"
}

output "public_ips" {
  value       = aws_instance.chianode.*.public_ip
  description = "the public ipv4 for this instance"
}

output "ipv6_addresses" {
  value       = aws_instance.chianode.*.ipv6_addresses
  description = "the ipv6 ipv6_addresses for this instance"
}

output "private_ips" {
  value       = aws_instance.chianode.*.private_ip
  description = "the private ipv4 for this instance"
}

output "instance_ids" {
  value       = aws_instance.chianode.*.id
  description = "Instance IDs for all instances created in this module"
}

output "load_balancer_dns_names" {
  value = aws_lb.chianode.*.dns_name
}
