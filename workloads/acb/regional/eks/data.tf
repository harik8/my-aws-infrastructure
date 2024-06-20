data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = var.tf_state_s3_bucket
    key    = "vpc-main/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "acm" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = var.tf_state_s3_bucket
    key    = "acm/terraform.tfstate"
    region = var.aws_region
  }
}