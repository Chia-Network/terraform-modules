output "public_dns" {
value       = "${join(",", aws_instance.timelord.*.public_dns)}"
description = "the public dns for this timelord instance"
}

output "public_ip" {
value       = "${join(",", aws_instance.timelord.*.public_ip)}"
description = "the public ipv4 for this timelord instance"
}

output "ipv6_addresses" {
value       = "${join(",", aws_instance.timelord.*.ipv6_addresses)}"
description = "the ipv6 ipv6_addresses for this timelord instance"
}
