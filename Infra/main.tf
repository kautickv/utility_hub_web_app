provider "AzureCloud" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "front-end-react-soc-landing-3516514"
}
