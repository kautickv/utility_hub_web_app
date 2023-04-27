terraform {
  backend "s3" {
    bucket         = "password-generator-terraform-state-management-bucket"
    key            = "dev/passwordGeneratorTerraformState" 
    region         = "us-east-1" 
  }
}

provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "front-end-react-password-generator-3516514"
}
