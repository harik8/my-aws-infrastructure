variable "tags" {
  description = "A map of variables for the tags"
  type        = map(string)
  default = {
    description = ""
    environment = ""
    owner       = ""
    utilization = ""
    workload    = ""
  }
}

variable "aws_region" {
  default     = ""
  description = "The AWS region"
  type        = string
}

variable "account_id" {
  default     = ""
  description = "The AWS Account id"
  type        = string
}