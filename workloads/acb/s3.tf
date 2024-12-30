module "s3-tfbackend" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=${local.module_versions.S3}"

  bucket = "${terraform.workspace}-tfbackend"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  tags = {
    Name = "${terraform.workspace}-tfbackend"
  }
}