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
    bucket         = "utility-hub-s3-prod-terraform-backend" # Create bucket prior to when script runs. State will be stored to this bucket. Add necessary permissions to bucket and user/role
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
provider "aws"{
  alias = "dns_account"
  region = var.dns_account_region

  access_key = var.dns_aws_access_key_id
  secret_key = var.dns_aws_secret_access_key
  token      = var.dns_aws_session_token
}