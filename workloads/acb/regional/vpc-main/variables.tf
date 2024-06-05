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

variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

