variable "domain_name" {}
variable "cloudflare_api_token" {}
variable "cloudfront_domain" {}
variable "validation_records" {
  description = "List of ACM DNS validation records"
  type = list(object({
    domain_name          = string
    resource_record_name = string
    resource_record_type = string
    resource_record_value = string
  }))
  default = []
}
