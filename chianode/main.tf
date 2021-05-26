data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.ami_pattern]
  }
}

resource "aws_instance" "chianode" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  ebs_optimized          = var.ebs_optimized

  tags = merge(tomap({
    "Name"        = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.deployset_tag}-${count.index + 1}",
    "application" = var.application_tag,
    "component"   = var.component_tag,
    "network"     = var.network_tag,
    "deployset"   = var.deployset_tag,
  }), var.extra_tags)

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "180m"
  }
}

resource "aws_lb" "chianode" {
  count = var.lb_enabled == true ? 1 : 0

  name               = "${var.component_tag}-${var.network_tag}-${var.deployset_tag}"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.subnets.ids
  ip_address_type    = var.lb_ipv6 == true ? "dualstack" : "ipv4"

  tags = merge(tomap({
    "Name"        = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.deployset_tag}",
    "application" = var.application_tag,
    "component"   = var.component_tag,
    "network"     = var.network_tag,
    "deployset"   = var.deployset_tag
  }), var.extra_tags)
}

resource "aws_lb_target_group" "chianode" {
  count = var.lb_enabled == true ? 1 : 0

  name     = "${var.component_tag}-${var.network_tag}-${var.deployset_tag}"
  port     = var.lb_port
  protocol = var.lb_protocol
  vpc_id   = var.vpc_id

  tags = merge(tomap({
    "Name"        = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.deployset_tag}",
    "application" = var.application_tag,
    "component"   = var.component_tag,
    "network"     = var.network_tag,
    "deployset"   = var.deployset_tag
  }), var.extra_tags)
}

resource "aws_lb_listener" "chianode" {
  count = var.lb_enabled == true ? 1 : 0

  load_balancer_arn = aws_lb.chianode[0].arn
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chianode[0].arn
  }
}

resource "aws_lb_target_group_attachment" "chianode" {
  count = var.lb_enabled == true ? var.instance_count : 0

  target_group_arn = aws_lb_target_group.chianode[0].arn
  target_id        = aws_instance.chianode[count.index].id
  port             = var.lb_port
}

data "cloudflare_zones" "zone" {
  count = var.set_cloudflare_dns ? 0 : 1

  filter {
    name = var.cloudflare_zone
  }
}

resource "cloudflare_record" "loadbalancers" {
  count = var.set_cloudflare_dns ? 0 : 1

  zone_id = data.cloudflare_zones.zone[0].id
  name    = "${var.dns_name_prefix}-${var.deployset_tag}"
  value   = aws_lb.chianode[0].dns_name
  type    = "CNAME"
  ttl     = var.dns_ttl
}
