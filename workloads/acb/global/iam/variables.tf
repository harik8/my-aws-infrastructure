variable "tags" {
  description = "A map of variables for the tags"
  type        = map(string)
  default     = {}
}

variable "account_id" {
  description = "The AWS Account id"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}