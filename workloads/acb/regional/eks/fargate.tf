module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  name         = module.eks.cluster_name
  cluster_name = module.eks.cluster_name

  subnet_ids = data.terraform_remote_state.vpc.outputs.vpc["private_subnets"]
  selectors = [
    {
        namespace = "karpenter-beta"
    }
  ]

  tags = module.tag.default_tags
}