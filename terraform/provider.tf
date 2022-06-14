# ========== Terraform ==============
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# ========== AWS ==============
provider "aws" {
  region = var.region
}