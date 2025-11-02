terraform {
  backend "s3" {
    bucket         = "parallelservicesllc-tfstate"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "parallelservicesllc-tf-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}
provider "aws" {
  region = "us-east-1"
}