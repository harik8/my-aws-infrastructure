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

variable "cluster_version" {
  description = "The Kubernetes version."
  type        = string
}

variable "tf_state_s3_bucket" {
  description = "The S3 bucket stores tofu state."
  type        = string
}