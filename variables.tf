variable "cloudflare_api_token" {
  description = "API token for managing DNS in Cloudflare"
  type        = string
  sensitive   = true
  default     = ""   # 👈 allows terraform plan/apply without token in Phase 1
}