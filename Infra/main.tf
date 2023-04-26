provider "aws" {
  region = "us-east-1" # Set your desired AWS region
  profile = "password-generator-app-pipeline-user"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "front-end-react-soc-landing-3516514"
}
