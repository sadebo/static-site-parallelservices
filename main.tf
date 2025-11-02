provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

####################################################
# Import outputs from bootstrap Terraform state
####################################################
data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket         = "parallelservicesllc-tfstate"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "parallelservicesllc-tf-lock"
  }
}

####################################################
# Use outputs from bootstrap for OIDC role reference
####################################################
locals {
  oidc_role_arn = data.terraform_remote_state.bootstrap.outputs.github_role_arn
  oidc_provider_arn = data.terraform_remote_state.bootstrap.outputs.oidc_provider_arn
  account_id = data.terraform_remote_state.bootstrap.outputs.account_id
}

####################################################
# Static Website Modules
####################################################
module "s3_website" {
  source      = "./modules/s3_website"
  bucket_name = "parallelservicesllc-static-site"
  index_file  = "${path.module}/website/index.html"
  error_file  = "${path.module}/website/error.html"
}

module "cloudfront" {
  source             = "./modules/cloudfront"
  domain_name        = "parallelservicesllc.com"
  alt_domain_names   = ["www.parallelservicesllc.com"]
  bucket_domain_name = module.s3_website.bucket_domain_name
  bucket_arn         = module.s3_website.bucket_arn
}

module "cloudflare_dns" {
  source               = "./modules/cloudflare_dns"
  domain_name          = "parallelservicesllc.com"
  cloudflare_api_token = var.cloudflare_api_token
  cloudfront_domain    = module.cloudfront.distribution_domain
  validation_records   = module.cloudfront.acm_validation_records
}
