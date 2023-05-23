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
    bucket         = "password-generator-terraform-state-management-bucket" # Create bucket prior to when script runs. State will be stored to this bucket. Add necessary permissions to bucket and user/role
    key            = "dev/passwordGeneratorTerraformState" # Folder structure to where exactly to store state
    region         = var.region
  }
}

provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}
