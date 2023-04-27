terraform {
  backend "s3" {
    bucket         = "password-generator-terraform-state-management-bucket" # Create bucket prior to when script runs. State will be stored to this bucket. Add necessary permissions to bucket and user/role
    key            = "dev/passwordGeneratorTerraformState" # Folder structure to where exactly to store state
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "front-end-react-password-generator-3516514"
}
