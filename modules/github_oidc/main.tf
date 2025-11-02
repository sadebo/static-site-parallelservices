#############################################
# Module: GitHub OIDC Trust + IAM Role
#############################################

data "aws_caller_identity" "current" {}

# Create GitHub’s OIDC provider (if not already)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub’s public OIDC thumbprint
}

# IAM role trusted by GitHub Actions
resource "aws_iam_role" "github_oidc_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          # Restrict to your repo and branch (tightest security)
          "token.actions.githubusercontent.com:sub" = "repo:${var.repo}:ref:refs/heads/${var.branch}"
        }
      }
    }]
  })
}

# Policy to attach (Terraform + S3 + CloudFront)
resource "aws_iam_policy" "github_deploy_policy" {
  name        = "${var.role_name}-policy"
  description = "Permissions for Terraform deployment via GitHub OIDC"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "TerraformDeployAccess",
        Effect   = "Allow",
        Action   = [
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
  policy_arn = aws_iam_policy.github_deploy_policy.arn
}
