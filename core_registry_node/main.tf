# Find the Chia AMI to use for the EC2 instance
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.ami_pattern]
  }

  filter {
    name   = "architecture"
    values = [var.ami_arch]
  }
}

# governance and observer testnetA node
resource "aws_instance" "core-registry" {
  instance_type          = var.node_instance_type
  ami                    = data.aws_ami.ami.id
  subnet_id              = var.node_subnet
  vpc_security_group_ids = var.secgroups
  key_name               = var.key_name
  user_data              = var.user_data
  iam_instance_profile   = var.instance_profile

  root_block_device {
    volume_type = "gp3"
    volume_size = "var.volume_size"
  }

  tags = {
    Name = var.client_name
  }

  # Don't want this rebuilding ever as it is a single-server application
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "180m"
  }
}

# Elastic IP for the node to make it easily routable for public HTTPS requests
resource "aws_eip" "core-registry-eip" {
  count    = var.eip ? 1 : 0
  instance = var.eip ? aws_instance.core-registry.id : null
  vpc      = var.eip ? true : null
}


resource "aws_cloudwatch_metric_alarm" "instance_reboot_on_failure_registry" {
  alarm_name          = "StatusCheck: ${aws_instance.core-registry.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1.0"
  alarm_description   = "EC2 Status Check"
  alarm_actions       = ["arn:aws:automate:${var.region}:ec2:reboot"]
  dimensions = {
    InstanceId = aws_instance.core-registry.id
  }
}

data "cloudflare_zone" "zone" {
  name = var.cf_zone
}

# Define the IP address based on the condition
locals {
  ip_address = var.eip ? aws_eip.core-registry-eip[0].public_ip : aws_instance.core-registry.public_ip
}

# Cloudflare record creation
resource "cloudflare_record" "app-dns" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.app_domain
  value   = local.ip_address
  type    = "A"
  proxied = var.cf_app_proxied  # Note: Use false instead of "false"
}

resource "cloudflare_record" "datalayer-dns" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.data_domain
  value   = local.ip_address
  type    = "A"
  proxied = var.cf_datalayer_proxied
}
