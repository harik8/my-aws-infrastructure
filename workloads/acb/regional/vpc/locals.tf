locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name                     = join("-", [module.tag.default_tags["Prefix"], "pri", var.tags["utilization"]]),
      Description              = "The private subnet of vpc main",
      "karpenter.sh/discovery" = "acb-eun1-sandbox-eks"
    }
  )

  public_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "pub", var.tags["utilization"]])
      Description = "The public subnet of vpc main"
    }
  )

  nat_instance_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nat"])
      Description = "The NAT instance of vpc main"
    }
  )

  intra_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name                     = join("-", [module.tag.default_tags["Prefix"], "intra-subnet"]),
      Description              = "The intra subnet of vpc main",
      "kubernetes.io/role/cni" = 1
    }
  )
}