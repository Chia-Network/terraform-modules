output "dns_name" {
value       = aws_elb.chia_backup_lb.dns_name
description = "the public dns for this timelord instance"
}
