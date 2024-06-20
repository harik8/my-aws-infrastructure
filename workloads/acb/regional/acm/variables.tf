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

variable "domain_name" {
  description = "The domain name."
  type        = string
}

variable "subject_alternative_names" {
  description = "SAN for the ACM."
  type        = list(string)
}

variable "zone_id" {
  description = "The Hosted Zone Id."
  type        = string
}

variable "validation_record_fqdns" {
  description = "FQDNs to validate the record."
  type        = list(string)
}