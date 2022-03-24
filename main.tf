provider "aws" {
  default_tags {
    tags = {
      environment = "Production"
      region      = var.aws_region
      service     = local.service_name
    }
  }
}

terraform {
  required_version = "= 1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
  }
  backend "s3" {
    bucket = "tf-marklin"
    key    = "state"
    region = "us-west-2"
  }
}
