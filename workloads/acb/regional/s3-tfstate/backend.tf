terraform {
  backend "s3" {
    bucket         = "acb-eun1-sandbox-tfstate"
    key            = "s3-tfstate/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "acb-eun1-sandbox-tflock"
  }
}