module "tag" {
#  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"
  source = "/home/hari-karthigasu/Private/Git/tofu-modules/modules/tag"

  description = var.tags.description
  environment = var.tags.environment
  name        = var.tags.name
  workload    = var.tags.workload
  team        = var.tags.team
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.8.1"

  cidr = var.vpc_cidr

  azs = local.azs
  # private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  public_subnet_tags = local.private_subnet_tags
  # private_subnet_tags = local.public_subnet_tags

  enable_nat_gateway = false
  # single_nat_gateway = true

  tags = local.vpc_tags
}