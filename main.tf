provider "aws" {
  region = "us-east-1"
}

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
  source              = "./modules/cloudflare_dns"
  domain_name         = "parallelservicesllc.com"
  cloudflare_api_token = var.cloudflare_api_token
  cloudfront_domain   = module.cloudfront.distribution_domain
  validation_records  = module.cloudfront.acm_validation_records
}

# module "github_oidc" {
#   source = "./modules/github_oidc"

#   repo       = "sadebo/static-site-parallelservices"
#   branch     = "main"
#   role_name  = "github-terraform-deploy"
# }