locals {
  eks_managed_node_groups_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Name"], "managed"]),
      Description = "The eks managed node group."
    }
  )

  self_managed_node_groups_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Name"], "self"]),
      Description = "The self managed node group."
    }
  )

  nlb_public_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nlb-public"]),
      Description = "The public NLB."
    }
  )
}
