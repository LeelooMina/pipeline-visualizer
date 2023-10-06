terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    encrypt        = true
    bucket         = "beta-project-heliodor-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "beta-project-heliodor-tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.environment
      Product     = local.product_name
      Description = "Managed by Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "domain_cert" {
  domain      = "*.${local.domain_name}"
  most_recent = true
  statuses    = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name = local.domain_name
}
