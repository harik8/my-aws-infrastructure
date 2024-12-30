provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/InfraAsCode"
    session_name = "InfraAsCode-${terraform.workspace}"
  }

  default_tags {
    tags = {
      Environment = split("-", "${terraform.workspace}")[1]
      OpenTofu    = true
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "${terraform.workspace}-tfbackend"
    key            = "${terraform.workspace}.tfstate"
    dynamodb_table = "${terraform.workspace}-tfbackend-lock"
    region         = var.aws_region
    encrypt        = true
  }
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "al2023_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, length(data.aws_availability_zones.available.names))
}
