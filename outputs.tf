output "website_url" {
  value = "https://parallelservicesllc.com"
}

output "github_oidc_role_from_bootstrap" {
  value = data.terraform_remote_state.bootstrap.outputs.github_role_arn
}

output "bootstrap_provider_arn" {
  value = data.terraform_remote_state.bootstrap.outputs.oidc_provider_arn
}

output "bootstrap_account_id" {
  value = data.terraform_remote_state.bootstrap.outputs.account_id
}
