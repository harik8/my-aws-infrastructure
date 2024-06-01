module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  workload    = var.tags.workload
  utilization = var.tags.utilization
  owner       = var.tags.owner
}

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
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  tags = module.tag.default_tags
}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt ${module.tag.default_tags["Name"]} bucket objects"
  deletion_window_in_days = 7

  tags = module.tag.default_tags
}

resource "aws_kms_alias" "main" {
  name          = "alias/${module.tag.default_tags["Name"]}"
  target_key_id = aws_kms_key.objects.key_id
}