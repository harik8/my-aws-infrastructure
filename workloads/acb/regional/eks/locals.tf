locals {
  nlb_public_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nlb-public"]),
      Description = "The public NLB."
    }
  )
}
