#Create bucket to store React build files
resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
}

# Create and assign a bucket policy to block all public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "static_hosting_bucket_name" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
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