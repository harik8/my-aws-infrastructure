output "iam_github_oidc_provider" {
  value = module.iam_github_oidc_provider
}

# output "iam_github_oidc_role" {
#   value = module.iam_github_oidc_role
# }

output "arn" {
  value = aws_iam_role.github_role.arn
}

output "eks_cd_role_arn" {
  value = aws_iam_role.eks_cd_role.arn
}