module "ddb-tfbackend-lock" {
  source = "github.com/terraform-aws-modules/terraform-aws-dynamodb-table?ref=${local.module_versions.DDB}"

  name                           = "${terraform.workspace}-tfbackend-lock"
  hash_key                       = "LockID"
  deletion_protection_enabled    = true
  server_side_encryption_enabled = true

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = {
    Name = "${terraform.workspace}-tfbackend-lock"
  }
}