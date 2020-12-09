output "public_dns" {
value       = aws_instance.farmer[0].public_dns
description = "the public dns for this farmer instance"
}

output "public_ip" {
value       = aws_instance.farmer[0].public_ip
description = "the public ipv4 for this farmer instance"
}

output "ipv6_addresses" {
value       = aws_instance.farmer[0].ipv6_addresses
description = "the ipv6 ipv6_addresses for this farmer instance"
}

output "public_dns2" {
value       = aws_instance.farmer[1].public_dns
description = "the public dns for this farmer instance"
}

output "public_ip2" {
value       = aws_instance.farmer[1].public_ip
description = "the public ipv4 for this farmer instance"
}

output "ipv6_addresses2" {
value       = aws_instance.farmer[1].ipv6_addresses
description = "the ipv6 ipv6_addresses for this farmer instance"
}

output "public_dns3" {
value       = aws_instance.farmer[2].public_dns
description = "the public dns for this farmer instance"
}

output "public_ip3" {
value       = aws_instance.farmer[2].public_ip
description = "the public ipv4 for this farmer instance"
}

output "ipv6_addresses3" {
value       = aws_instance.farmer[2].ipv6_addresses
description = "the ipv6 ipv6_addresses for this farmer instance"
}
