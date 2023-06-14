#Create bucket to store React build files
resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Configure s3 bucket for static hosting
resource "aws_s3_bucket_website_configuration" "static_hosting_bucket_config" {
    bucket = aws_s3_bucket.static_hosting_bucket_name.id
}

# Create a Cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "static_hosting_oai" {
  comment = "Access identity for static hosting"
}

#Create a json object for s3 bucket policy to make bucket public
data "aws_iam_policy_document" "s3_allow_cloudfront_access" {
  statement {
    sid = "AllowCloudfrontAccess"
    effect = "Allow"
    principals {
      type = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.static_hosting_oai.s3_canonical_user_id]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
                 "${aws_s3_bucket.static_hosting_bucket_name.arn}/*"
    ]
  }
}

# Assign the above policy to s3 static hosting bucket
resource "aws_s3_bucket_policy" "s3_allow_public_access" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id
  policy = data.aws_iam_policy_document.s3_allow_cloudfront_access.json
}

# Print the bucket id
output "S3_bucket_hosting_id" {
  value = aws_s3_bucket.static_hosting_bucket_name.id
}

# Print the bucket website endpoint to terminal
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
}