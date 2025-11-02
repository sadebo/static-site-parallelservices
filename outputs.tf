output "website_url" {
  value = "https://parallelservicesllc.com"
}

output "cloudfront_domain" {
  value = module.cloudfront.distribution_domain
}
