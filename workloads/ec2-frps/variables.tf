variable "tags" {
  description = "A map of variables for the tags"
  type        = map(string)
  default = {
    description = ""
    environment = ""
    name        = ""
    workload    = ""
    team        = ""
  }
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "account_id" {
  description = "The AWS Account id"
  type        = string
}

variable "manage_account_id" {
  description = "The AWS Account id of manage"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for FRPS"
  type = list(string)
}

variable "tofu_state_s3_bucket" {
  description = "The S3 bucket stores tofu state."
  type        = string
}