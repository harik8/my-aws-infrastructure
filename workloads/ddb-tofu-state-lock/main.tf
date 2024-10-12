provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/InfraAsCode"
    session_name = "InfraAsCode"
  }
}

module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  workload    = var.tags.workload
  owner       = var.tags.owner
}

module "dynamodb" {
  source = "github.com/terraform-aws-modules/terraform-aws-dynamodb-table?ref=v4.0.1"

  name                               = join("-", [module.tag.default_tags["Prefix"], "tofu-state-lock"])
  hash_key                           = "LockID"
  deletion_protection_enabled        = true
  server_side_encryption_enabled     = true

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "tofu-state-lock"])
      Description = "The DynamoDB table for tofu state lock."
    }
  )
}