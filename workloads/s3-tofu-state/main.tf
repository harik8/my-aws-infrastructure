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

module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "v4.1.2"

  bucket = join("-", [module.tag.default_tags["Prefix"], "tofu-state"])
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  lifecycle_rule = [
    {
      id      = join("-", [module.tag.default_tags["Prefix"], "tofu-state-INT-TIERING"])
      enabled = true

      transition = [
        {
          storage_class = "INTELLIGENT_TIERING"
        }
      ]
    }
  ]

  tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "tofu-state"])
      Description = "The S3 Bucket to store tofu state."
    }
  )
}