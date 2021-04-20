output "public_dns" {
value       = aws_instance.seedbox[0].public_dns
description = "the public dns for this seedbox instance"
}

output "public_ip" {
value       = aws_instance.seedbox[0].public_ip
description = "the public ipv4 for this seedbox instance"
}

output "ipv6_addresses" {
value       = aws_instance.seedbox[0].ipv6_addresses
description = "the ipv6 ipv6_addresses for this seedbox instance"
}
