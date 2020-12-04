output "public_dns${count.index}" {
value       = "aws_instance.timelord.[${count.index}].public_dns"
description = "the public dns for this timelord instance"
}

output "public_ip${count.index}" {
value       = "aws_instance.timelord.[${count.index}].public_ip"
description = "the public ipv4 for this timelord instance"
}

output "ipv6_addresses${count.index}" {
value       = "aws_instance.timelord.[${count.index}].ipv6_addresses"
description = "the ipv6 ipv6_addresses for this timelord instance"
}
