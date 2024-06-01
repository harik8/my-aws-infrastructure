module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  workload    = var.tags.workload
  utilization = var.tags.utilization
  owner       = var.tags.owner
}

module "dynamodb" {
  source = "github.com/terraform-aws-modules/terraform-aws-dynamodb-table?ref=v4.0.1"

  name                               = module.tag.default_tags["Name"]
  hash_key                           = "LockID"
  deletion_protection_enabled        = true
  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = aws_kms_key.main.arn

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = module.tag.default_tags
}

resource "aws_kms_key" "main" {
  description             = "KMS key is used to encrypt ${module.tag.default_tags["Name"]} dynamodb"
  deletion_window_in_days = 7

  tags = module.tag.default_tags
}

resource "aws_kms_alias" "main" {
  name          = "alias/${module.tag.default_tags["Name"]}"
  target_key_id = aws_kms_key.main.key_id
}