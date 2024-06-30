module "iam_github_oidc_provider" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-github-oidc-provider?ref=v5.39.1"

  tags = merge(
    module.tag.default_tags,
    {
      Name        = local.github_name
      Description = "The OIDC provider for Github."
    }
  )
}

resource "aws_iam_role" "github_role" {
  name = local.github_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "GithubOidcAuth",
        Effect = "Allow",
        Principal = {
          AWS       = "arn:aws:iam::${var.account_id}:role/${local.github_name}",
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = [
          "sts:AssumeRole",
          "sts:AssumeRoleWithWebIdentity"
        ],
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:harik8/services:*"
          },
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_eks" {
  name        = local.github_name
  description = "IAM policy to allow Github role to access EKS."
  policy      = data.aws_iam_policy_document.github_eks.json

  tags = merge(
    module.tag.default_tags,
    {
      Name        = local.github_name
      Description = "The IAM policy for Github role."
    }
  )
}

resource "aws_iam_role_policy_attachment" "github_eks" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_eks.arn
}

resource "aws_iam_role" "eks_cd_role" {
  name = local.github_eks_cd_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "GithubActionsEKSDeploy",
        Effect = "Allow",
        Principal = {
          AWS       = aws_iam_role.github_role.arn
        },
        Action = [
          "sts:AssumeRole",
        ]
      }
    ]
  })

  tags = merge(
    module.tag.default_tags,
    {
      Name        = local.github_eks_cd_name
      Description = "The IAM role for EKS deployment."
    }
  )
}