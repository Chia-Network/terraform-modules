output "public_dns" {
  value       = aws_instance.faucet-node[0].public_dns
  description = "the public dns for this instance"
}

output "public_ip" {
  value       = aws_instance.faucet-node[0].public_ip
  description = "the public ipv4 for this instance"
}

output "ipv6_addresses" {
  value       = aws_instance.faucet-node[0].ipv6_addresses
  description = "the ipv6 ipv6_addresses for this instance"
}

output "private_ip" {
  value       = aws_instance.faucet-node[0].private_ip
  description = "the private ipv4 for this instance"
}
