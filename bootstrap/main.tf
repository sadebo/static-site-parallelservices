# provider "aws" {
#   region = var.aws_region
# }

#############################################
# GitHub OIDC Provider (one-time setup)
#############################################
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#############################################
# IAM Role for GitHub Actions (with proper aud)
#############################################
resource "aws_iam_role" "github_oidc_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "GitHubOIDCTrust",
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          # Audience must always equal sts.amazonaws.com
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          # Allow any ref (branch/tag/pr) within your repo
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.repo}:*"
          }
        }
      }
    ]
  })
}

#############################################
# Policy: Terraform + S3 + CloudFront + ACM + Logs
#############################################
resource "aws_iam_policy" "terraform_policy" {
  name        = "${var.role_name}-policy"
  description = "Allows Terraform to manage S3, CloudFront, ACM, and logs via OIDC"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "TerraformAccess",
        Effect = "Allow",
        Action = [
          "s3:*",
          "cloudfront:*",
          "acm:*",
          "iam:GetRole",
          "iam:PassRole",
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}
