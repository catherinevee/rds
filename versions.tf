terraform {
  required_version = "1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

# Terragrunt version: 0.84.0 