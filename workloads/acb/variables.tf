variable "account_id" {
  description = "The AWS Account ID"
}

variable "aws_region" {
  description = "The AWS region"
  default     = "eu-north-1"
}

variable "enable_test_instance" {
  description = "Enable test EC2 instance"
  default = false
}

variable "frps_allowed_cidr" {
  description = "Allowed CIDR to access FRPS"
  default     = []
}

variable "frps_playbook_s3_endpoint" {
  description = "The S3 endpoint where frps ansible playbook stored"
  default     = ""
}

variable "frps_playbook_vars" {
  description = "The variables and values for frps ansible playbook"
  default     = "SSM=True frp_version=0.60.0"
}

variable "manage_account_id" {
  description = "The Account ID of manage account"
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.80.0.0/16"
}