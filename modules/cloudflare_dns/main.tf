# data "cloudflare_zone" "zone" {
#   name = var.domain_name
# }

resource "cloudflare_record" "acm_validation" {
  count = length(var.validation_records)

  zone_id = data.cloudflare_zone.zone.id
  name    = var.validation_records[count.index].resource_record_name
  type    = var.validation_records[count.index].resource_record_type
  content = var.validation_records[count.index].resource_record_value  # ✅ correct
  ttl     = 300
}


resource "cloudflare_record" "root" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.domain_name
  type    = "CNAME"
  content   = var.cloudfront_domain
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "www"
  type    = "CNAME"
  content   = var.cloudfront_domain
  proxied = true
}
