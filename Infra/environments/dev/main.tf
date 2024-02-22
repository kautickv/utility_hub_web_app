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
    region         = "us-east-1" # Region
  }
}

provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

# Used only for Certificate manager
provider "aws" {
  alias = "acm"
  region = "us-east-1"
}
