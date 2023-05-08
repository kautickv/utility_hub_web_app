
# Create a s3 bucket to store zip of lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "password-generator-lambda-python-backend-code-s3-bucket"
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