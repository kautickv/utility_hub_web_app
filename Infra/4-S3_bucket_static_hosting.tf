#Create bucket to store React build files
resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
}

# Configure bucket to enable cors
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

#Create a json object for s3 bucket policy to make bucket public
data "aws_iam_policy_document" "s3_read_permissions" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = ["${aws_s3_bucket.static_hosting_bucket_name.arn}/*"]
  }
}

# Assign the above policy to s3 static hosting bucket
resource "aws_s3_bucket_policy" "s3_allow_public_access" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id
  policy = data.aws_iam_policy_document.s3_read_permissions.json
}