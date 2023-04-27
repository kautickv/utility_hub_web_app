terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-1651165"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}