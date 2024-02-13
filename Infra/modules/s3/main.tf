resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy
}


# Create and assign a bucket policy to block all public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}