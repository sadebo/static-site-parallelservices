output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "role_arn" {
  value = aws_iam_role.github_oidc_role.arn
}

output "policy_arn" {
  value = aws_iam_policy.github_deploy_policy.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
