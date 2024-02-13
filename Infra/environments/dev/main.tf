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


# Create a s3 bucket to store zip of lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "test-lambda-bucket-to-store-dummy-files-452"
  force_destroy = true
}

# Create and assign a bucket policy to block all public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
