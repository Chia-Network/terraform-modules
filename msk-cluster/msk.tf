data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "sub1" {
  filter {
    name = "tag:Name"
    values = ["${var.subnet_1_name}"]
  }
}

data "aws_subnet" "sub2" {
  filter {
    name = "tag:Name"
    values = ["${var.subnet_2_name}"]
  }
}

data "aws_subnet" "sub3" {
  filter {
    name = "tag:Name"
    values = ["${var.subnet_3_name}"]
  }
}

resource "aws_security_group" "chiametrics" {
  name = var.security_group_name
  description = "Security group for Chia Metrics Kafka Service"
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Application = var.application
    Name = var.security_group_name
  }

  ingress {
    from_port = 9092
    protocol = "tcp"
    to_port = 9092
    cidr_blocks = ["10.0.0.0/0"]
  }

  ingress {
    from_port = 9094
    protocol = "tcp"
    to_port = 9094
    cidr_blocks = ["10.0.0.0/0"]
  }

  ingress {
    from_port = 2181
    protocol = "tcp"
    to_port = 2181
    cidr_blocks = ["10.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_configuration" "chiametrics" {
  kafka_versions = ["2.2.1"]
  name           = "ChiaKafka"

  server_properties = <<PROPERTIES
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
socket.request.max.bytes=104857600
unclean.leader.election.enable=true
message.max.bytes=104857600
PROPERTIES
}

resource "aws_msk_cluster" "chiametrics" {
  cluster_name = var.msk_name
  kafka_version = "2.2.1"
  number_of_broker_nodes = 3

  configuration_info {
    arn      = aws_msk_configuration.chiametrics.arn
    revision = aws_msk_configuration.chiametrics.latest_revision
  }

  broker_node_group_info {
    client_subnets = [
      data.aws_subnet.sub1.id,
      data.aws_subnet.sub2.id,
      data.aws_subnet.sub3.id,
    ]
    ebs_volume_size = "300"
    instance_type = "kafka.t3.small"
    security_groups = [
      aws_security_group.chiametrics.id
    ]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  tags = {
    Application = var.application
    Name = var.msk_name
  }
}

data "aws_route53_zone" "r53_zone_data" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "chia_metrics_dns_es" {
  zone_id = data.aws_route53_zone.r53_zone_data.id
  name = "${var.broker_hostname}.${var.hosted_zone}"
  type = "TXT"
  ttl = 60
  records = [aws_msk_cluster.chiametrics.bootstrap_brokers]
}
