output "distribution_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "acm_validation_records" {
  value = aws_acm_certificate.cert.domain_validation_options
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
