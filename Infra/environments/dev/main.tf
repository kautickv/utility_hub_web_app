terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  backend "s3" {
    bucket         = "utility-hub-s3-terraform-backend" # Create bucket prior to when script runs. State will be stored to this bucket. Add necessary permissions to bucket and user/role
    key            = "terraformStateFiles" # Folder structure to where exactly to store state
    region         = "us-east-1"
  }
}

# Default AWS Account
provider "aws" {
  # Use default credentials
  region = var.aws_default_region
}

# Used only for Certificate manager
provider "aws" {
  # use default credentials
  alias = "acm"
  region = "us-east-1"

}

#Provider for DNS Account setup
provider "aws" {
  alias  = "dns_account"
  region = var.dns_account_region

  # Only assume role if it's different from the default role
  dynamic "assume_role" {
    for_each = var.dns_iam_role_arn != var.default_iam_role_arn ? [1] : []
    content {
      role_arn     = var.dns_iam_role_arn
      session_name = "TerraformSession"
    }
  }
}

output "default_iam_role_arn_debug" {
  value = "Default IAM Role: '${var.default_iam_role_arn}'"
}

output "dns_iam_role_arn_debug" {
  value = "DNS IAM Role: '${var.dns_iam_role_arn}'"
}

output "comparison_result" {
  value = var.dns_iam_role_arn != var.default_iam_role_arn ? "Different" : "Same"
}