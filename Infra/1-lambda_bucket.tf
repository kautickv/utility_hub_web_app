
# Create a s3 bucket to store zip of lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "password_generator_lambda_python_backend_code_s3_bucket"
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