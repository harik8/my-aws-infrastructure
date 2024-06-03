module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  workload    = var.tags.workload
  utilization = var.tags.utilization
  owner       = var.tags.owner
}

#----
# S3 
#----

module "s3" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v4.1.2"

  bucket = module.tag.default_tags["Name"]
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.bucket.arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  tags = module.tag.default_tags
}

resource "aws_kms_key" "bucket" {
  description             = "KMS key is used to encrypt ${module.tag.default_tags["Name"]} bucket objects"
  deletion_window_in_days = 7

  tags = module.tag.default_tags
}

resource "aws_kms_alias" "bucket" {
  name          = "alias/${module.tag.default_tags["Name"]}-i"
  target_key_id = aws_kms_key.bucket.key_id
}

#-----------
# DYNAMO DB 
#-----------

module "dynamodb" {
  source = "github.com/terraform-aws-modules/terraform-aws-dynamodb-table?ref=v4.0.1"

  name                               = module.tag.default_tags["Name"]
  hash_key                           = "LockID"
  deletion_protection_enabled        = true
  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = aws_kms_key.dynamodb.arn

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = module.tag.default_tags
}

resource "aws_kms_key" "dynamodb" {
  description             = "KMS key is used to encrypt ${module.tag.default_tags["Name"]} dynamodb"
  deletion_window_in_days = 7

  tags = module.tag.default_tags
}

resource "aws_kms_alias" "dynamodb" {
  name          = "alias/${module.tag.default_tags["Name"]}-l"
  target_key_id = aws_kms_key.dynamodb.key_id
}