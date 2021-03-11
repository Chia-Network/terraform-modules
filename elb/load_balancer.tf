#
# ELB
#  * lb
#
resource "aws_elb" "lb" {
  name               = var.lb_name
  availability_zones = var.availability_zones

  #listener {
  #  instance_port     = 80
  #  instance_protocol = "http"
  #  lb_port           = 80
  #  lb_protocol       = "http"
#  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_certificate
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/health-check"
    interval            = 30
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.lb_name
    application = var.application_tag
  }
}
