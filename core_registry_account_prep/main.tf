# Create security groups for an EC2 instance to host
# core-registry apps with a Chia full node.  Accepts
# a variable for the full node port to make it compatible
# with mainnet or testnet.

resource "aws_security_group" "allow-all-outbound" {
  name        = "allow-all-outbound"
  description = "Allow outbound traffic only"
  vpc_id      = var.node_vpc

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow outbound traffic unrestricted"
  }
}

resource "aws_security_group" "testnet-full-node" {
  name        = "testnetfullnode"
  description = "Open ports needed for a testnet full node with HTTP/HTTPS hosting"
  vpc_id      = var.node_vpc

  ingress {
    from_port   = var.testnet_fullnode_port
    to_port     = var.testnet_fullnode_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Chia Full Node"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }
}

resource "aws_security_group" "mainnet-full-node" {
  name        = "mainnetfullnode"
  description = "Open ports needed for a mainnet full node with HTTP/HTTPS hosting"
  vpc_id      = var.node_vpc

  ingress {
    from_port   = var.mainnet_fullnode_port
    to_port     = var.mainnet_fullnode_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Chia Full Node"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }
}

# Create an SSH key for EC2 instances.
resource "aws_key_pair" "core-registry-keypair" {
  key_name = var.key_name
  public_key = var.public_key
}
