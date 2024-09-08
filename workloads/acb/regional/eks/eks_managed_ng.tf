module "eks_managed_node_group" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks//modules/eks-managed-node-group?ref=${local.eks_managed_node_group}"

  name                 = module.tag.default_tags["Name"]
  cluster_name         = module.eks.cluster_name
  cluster_version      = var.cluster_version
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids = data.terraform_remote_state.vpc.outputs.vpc["private_subnets"]

  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id]

  ami_type = "AL2_ARM_64"

  min_size     = 1
  max_size     = 1
  desired_size = 1

  instance_types = ["t4g.small"]
  capacity_type  = "SPOT"


  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_type = "gp3"
        encrypted   = true
      }
    }
  }

  taints = {
    dedicated = {
      key    = "application"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }

  iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  tags = module.tag.default_tags
}