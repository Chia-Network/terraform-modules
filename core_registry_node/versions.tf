terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.40.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.28"
    }
  }
  required_version = ">= 0.15"
}
