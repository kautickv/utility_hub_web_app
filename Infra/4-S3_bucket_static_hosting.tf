resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_cors_configuration" "static_bucket_cors_config" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}