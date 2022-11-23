output "load_balancer_dns_name" {
  description = "DNS Name for the load balancer"
  value       = aws_lb.asg.dns_name
}
