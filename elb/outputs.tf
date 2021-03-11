output "dns_name" {
value       = aws_elb.lb.dns_name
description = "the public dns for this timelord instance"
}
