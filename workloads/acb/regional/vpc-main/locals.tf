locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnet_tags = merge(
    module.tag.default_tags,
    { Name = join("-", [var.tags.workload, "private-subnet"]) }
  )

  public_subnet_tags = merge(
    module.tag.default_tags,
    { Name = join("-", [var.tags.workload, "public-subnet"]) }
  )

  vpc_tags = merge(
    module.tag.default_tags,
    { Name = join("-", [var.tags.workload, "vpc"]) }
  )
}