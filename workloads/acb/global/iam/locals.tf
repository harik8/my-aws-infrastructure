locals {
  github_name = join("-", [module.tag.default_tags["Prefix"], "gh-action"])
  github_eks_cd_name = join("-", [module.tag.default_tags["Prefix"], "gh-eks-deploy"])
}