output "public_dns" {
value       = aws_instance.introducer[0].public_dns
description = "the public dns for this introducer instance"
}

output "public_ip" {
value       = aws_instance.introducer[0].public_ip
description = "the public ipv4 for this introducer instance"
}

output "ipv6_addresses" {
value       = aws_instance.introducer[0].ipv6_addresses
description = "the ipv6 ipv6_addresses for this introducer instance"
}
