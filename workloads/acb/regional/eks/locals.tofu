locals {
  nlb_public_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nlb-public"]),
      Description = "The public NLB."
    }
  )
  eks                     = "v20.24.0"
  eks_managed_node_group  = "v20.13.1"
  loki_stack              = "2.10.2"
  nginx_ingress           = "4.10.1"
  nlb                     = "v8.7.0"
  self_managed_node_group = "v20.13.1"
}
