module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  utilization = var.tags.utilization
  workload    = var.tags.workload
  owner       = var.tags.owner
}

module "eks" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v20.13.1"

  cluster_name    = module.tag.default_tags["Name"]
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    # aws-ebs-csi-driver = {
    #   most_recent = true
    # }
  }

  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc["vpc_id"]
  subnet_ids               = data.terraform_remote_state.vpc.outputs.vpc["private_subnets"]
  control_plane_subnet_ids = data.terraform_remote_state.vpc.outputs.vpc["private_subnets"]

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    github = {
      kubernetes_groups = []
      user_name         = "GithubActions"
      principal_arn     = data.terraform_remote_state.iam.outputs.eks_cd_role_arn
      policy_associations = {
        github = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}