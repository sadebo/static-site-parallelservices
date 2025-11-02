# variable "domain_name" {}
# variable "cloudflare_api_token" {}
# variable "cloudfront_domain" {}
# variable "validation_records" {
#   type = list(object({
#     domain_name         = string
#     resource_record_name = string
#     resource_record_type = string
#     resource_record_value = string
#   }))
# }

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }

# data "cloudflare_zone" "zone" {
#   name = var.domain_name
# }

# DNS records for ACM validation
resource "cloudflare_record" "acm_validation" {
  for_each = {
    for dvo in var.validation_records : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = data.cloudflare_zone.zone.id
  name    = each.value.name
  type    = each.value.type
  value   = each.value.value
  ttl     = 300
}

# DNS records for CloudFront
resource "cloudflare_record" "root" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.domain_name
  type    = "CNAME"
  value   = var.cloudfront_domain
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "www"
  type    = "CNAME"
  value   = var.cloudfront_domain
  proxied = true
}
