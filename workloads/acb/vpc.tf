module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=${local.module_versions.VPC}"

  cidr = var.vpc_cidr

  azs                = local.azs
  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  public_subnets  = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 12, k + 8)]
  intra_subnets   = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, k + 12)]

  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true

  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]
  intra_subnet_ipv6_prefixes   = [6, 7, 8]

  private_subnet_tags = {
    Name = "${terraform.workspace}-private"
  }
  public_subnet_tags = {
    Name = "${terraform.workspace}-public"
  }
  intra_subnet_tags = {
    Name = "${terraform.workspace}-intra"
  }
  private_route_table_tags = {
    Name = "${terraform.workspace}-private"
  }
  public_route_table_tags = {
    Name = "${terraform.workspace}-public"
  }
  intra_route_table_tags = {
    Name = "${terraform.workspace}-intra"
  }

  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}