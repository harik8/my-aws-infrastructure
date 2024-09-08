provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/InfraAsCode"
    session_name = "InfraAsCode-${var.tags.workload}"
  }
}