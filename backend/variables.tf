variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to deploy the OIDC provider and IAM role"
}

variable "repo" {
  description = "GitHub repository in 'owner/repo' format"
  type        = string
  default = "sadebo/static-site-parallelservices"
}

variable "branch" {
  description = "Git branch allowed to assume the role"
  default     = "main"
}

variable "role_name" {
  description = "Name of the IAM role to create"
  default     = "github-terraform-deploy"
}
