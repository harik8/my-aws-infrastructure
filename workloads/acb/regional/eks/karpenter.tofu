module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = local.eks

  cluster_name = module.eks.cluster_name

  create_instance_profile = true
  enable_irsa             = true
  enable_pod_identity     = false

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter-beta:karpenter"]

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # This attaches us to existing node group where IAM role for our instance profile
  create_iam_role               = true
  node_iam_role_name            = "${module.eks.cluster_name}-KarpenterNodeInstanceProfile"
  node_iam_role_arn             = module.self_managed_node_group.iam_role_arn
  node_iam_role_use_name_prefix = false
  iam_role_use_name_prefix      = false
  iam_role_name                 = "${module.eks.cluster_name}-karpenter-irsa"

  tags = module.tag.default_tags
}


