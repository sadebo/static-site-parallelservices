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
# IAM Role for GitHub Actions
#############################################
resource "aws_iam_role" "github_oidc_role" {
  name = "github-terraform-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::423350936816:oidc-provider/token.actions.githubusercontent.com"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:sadebo/static-site-parallelservices:ref:refs/heads/main"
        },
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}


#############################################
# Basic Policy for Terraform Deployment
#############################################
resource "aws_iam_policy" "terraform_policy" {
  name        = "${var.role_name}-policy"
  description = "Allows Terraform to manage S3, CloudFront, and ACM via OIDC"
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
