variable "tags" {
  description = "A map of variables for the tags"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "account_id" {
  description = "The AWS Account id"
  type        = string
}

variable "tf_state_s3_bucket" {
  description = "The S3 bucket stores tofu state."
  type        = string
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "cloudwatch log group retention in days."
  type        = number
}