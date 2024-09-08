module "self_managed_node_group" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks//modules/self-managed-node-group?ref=${local.self_managed_node_group}"

  name                 = module.tag.default_tags["Name"]
  cluster_name         = module.eks.cluster_name
  cluster_version      = var.cluster_version
  cluster_endpoint     = module.eks.cluster_endpoint
  cluster_auth_base64  = module.eks.cluster_certificate_authority_data
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids = data.terraform_remote_state.vpc.outputs.vpc["private_subnets"]

  vpc_security_group_ids = [
    module.eks.cluster_primary_security_group_id,
    module.eks.cluster_security_group_id,
  ]

  min_size     = 1
  max_size     = 1
  desired_size = 1

  ami_type      = "AL2_ARM_64"
  instance_type = "t4g.large"

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_type = "gp3"
      }
    }
  }

  target_group_arns = module.nlb_public.target_group_arns

  iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  tags = module.tag.default_tags
}
