output "public_dns" {
value       = aws_instance.timelord[0].public_dns
description = "the public dns for this timelord instance"
}

output "public_ip" {
value       = aws_instance.timelord[0].public_ip
description = "the public ipv4 for this timelord instance"
}

output "ipv6_addresses" {
value       = aws_instance.timelord[0].ipv6_addresses
description = "the ipv6 ipv6_addresses for this timelord instance"
}

output "public_dns2" {
value       = aws_instance.timelord[1].public_dns
description = "the public dns for this timelord instance"
}

output "public_ip2" {
value       = aws_instance.timelord[1].public_ip
description = "the public ipv4 for this timelord instance"
}

output "ipv6_addresses2" {
value       = aws_instance.timelord[1].ipv6_addresses
description = "the ipv6 ipv6_addresses for this timelord instance"
}
