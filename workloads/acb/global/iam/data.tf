data "aws_iam_policy_document" "github_eks" {
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/*"]
  }
}