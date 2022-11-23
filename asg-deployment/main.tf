provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Name"        = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.ref_tag}-${var.group_tag}"
      "application" = var.application_tag
      "component"   = var.component_tag
      "network"     = var.network_tag
      "ref"         = var.ref_tag
      "group"       = var.group_tag
    }
  }
}

data "aws_region" "current" {}

data "aws_vpc" "asg" {
  filter {
    name   = "tag:Name"
    values = [
      var.vpc_name_filter
    ]
  }
}

data "aws_security_groups" "asg" {
  filter {
    name   = "tag:Name"
    values = var.security_groups
  }

  filter {
    name   = "vpc-id"
    values = [
      data.aws_vpc.asg.id
    ]
  }
}

data "aws_ami" "asg" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.ami_pattern]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnets" "asg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.asg.id]
  }
  filter {
    name   = "tag:Name"
    values = var.subnet_name_patterns
  }
}

resource "aws_lb" "asg" {
  // 32 Character max length, so substr to make sure this is always the case
  name               = substr("${var.component_tag}-${var.network_tag}", 0, 32)
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnets.asg.ids
}

resource "aws_lb_listener" "asg" {
  load_balancer_arn = aws_lb.asg.arn
  port              = var.lb_traffic_port
  protocol          = var.lb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  port                 = var.lb_traffic_port
  protocol             = var.lb_protocol
  vpc_id               = data.aws_vpc.asg.id
  deregistration_delay = 30

  health_check {
    interval            = 30
    unhealthy_threshold = 10
    healthy_threshold   = 10
    protocol            = var.lb_health_check_protocol
    port                = var.lb_health_check_port
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.ref_tag}-${var.group_tag}"
  desired_capacity          = var.instance_count
  max_size                  = var.instance_count
  min_size                  = var.instance_count
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  default_instance_warmup   = var.default_instance_warmup
  target_group_arns         = [aws_lb_target_group.asg.arn]
  vpc_zone_identifier       = data.aws_subnets.asg.ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = var.default_instance_warmup
    }
    triggers = ["tag"]
  }

  # Defines the settings for on-demand and/or spot instances
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = var.spot_allocation_strategy
      // The Spot Instances come from the pools with optimal capacity for the number of instances that are launching. You can optionally set a priority for each instance type.
      spot_instance_pools                      = var.spot_allocation_strategy == "lowest-price" ? var.spot_instance_pools : 0
      spot_max_price                           = var.spot_max_price
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.asg.id
        version            = aws_launch_template.asg.latest_version
      }

      override {
        instance_type = var.instance_type
      }
    }
  }
  tag {
    key                 = "AMI-ID"
    value               = data.aws_ami.asg.id
    propagate_at_launch = false
  }
}

resource "aws_launch_template" "asg" {
  name                   = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.ref_tag}-${var.group_tag}"
  image_id               = data.aws_ami.asg.id
  vpc_security_group_ids = data.aws_security_groups.asg.ids
  instance_type          = var.instance_type
  key_name               = var.key_name

  user_data = base64encode(var.user_data)

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type           = var.volume_type
      volume_size           = var.volume_size
      iops                  = var.volume_iops
      throughput            = var.volume_throughput
      delete_on_termination = "true"
      encrypted             = "false"
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      "Name"        = "${var.application_tag}-${var.component_tag}-${var.network_tag}-${var.ref_tag}-${var.group_tag}"
      "application" = var.application_tag
      "component"   = var.component_tag
      "network"     = var.network_tag
      "ref"         = var.ref_tag
      "group"       = var.group_tag
    }
  }
}
