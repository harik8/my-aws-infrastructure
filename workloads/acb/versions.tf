terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  module_versions = {
    DDB = "v4.2.0"
    S3  = "v4.3.0"
    VPC = "v5.17.0"
  }
}