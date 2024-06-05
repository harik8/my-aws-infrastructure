locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "private-subnet-main"]),
      Description = "The private subnet of vpc main"
    }
  )

  public_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "public-subnet-main"])
      Description = "The public subnet of vpc main"
    }
  )

  nat_instance_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nat-instance"])
      Description = "The NAT instance of vpc main"
    }
  )
}