variable "repo" {
  description = "GitHub repository in the format 'owner/repo'"
  type        = string
  default = "static-site-parallelsevices"
}

variable "branch" {
  description = "Branch name that can assume this role"
  type        = string
  default     = "main"
}

variable "role_name" {
  description = "Name for the IAM role to create"
  type        = string
  default     = "github-terraform-deploy"
}
