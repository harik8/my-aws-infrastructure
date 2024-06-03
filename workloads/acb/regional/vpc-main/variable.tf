variable "tags" {
  description = "A map of variables for the tags"
  type        = map(string)
  default = {
    description = "The description of the resource"
    environment = "The service environment"
    name        = "The name of the resource"
    workload    = "The AWS workload"
    team        = "The team manages"
  }
}

variable "aws_region" {
  default     = "eu-north-1"
  description = "The AWS region"
  type        = string
}

variable "account_id" {
  default     = ""
  description = "The AWS Account id"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "The VPC CIDR block"
  type        = string
}

