output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_role_arn" {
  description = "ARN of the IAM role that GitHub Actions will assume"
  value       = aws_iam_role.github_oidc_role.arn
}
output "github_policy_arn" {
  description = "ARN of the IAM policy attached to the GitHub OIDC role"
  value       = aws_iam_policy.terraform_policy.arn
}

data "aws_caller_identity" "current" {}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}
