output "tag" {
  value = module.tag
}

output "vpc" {
  value = module.vpc
}

output "test1" {
  value = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
}

output "az" {
  value = local.azs
}