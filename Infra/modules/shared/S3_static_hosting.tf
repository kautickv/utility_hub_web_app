# Create a bucket for hosting the React Application
module "s3_static_hosting" {
    source = "../../modules/s3"

    bucket_name = var.bucket_name
    force_destroy = true
}

# Block all public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "static_hosting_bucket_access_block" {
  bucket = module.s3_static_hosting.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure s3 bucket for static hosting
resource "aws_s3_bucket_website_configuration" "static_hosting_bucket_config" {
    bucket = module.s3_static_hosting.bucket_id

    index_document {
        suffix = "index.html"
    }

  error_document {
    key = "index.html"
  }
}

# Create a Cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "static_hosting_oai" {
  comment = "${var.app_name} - Access identity for static hosting"
}

#Create s3 bucket policy to allow only cloudfront read access
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
                 "${module.s3_static_hosting.bucket_arn}/*"
    ]
  }
}

# Assign the above policy to s3 static hosting bucket
resource "aws_s3_bucket_policy" "s3_allow_public_access" {
  bucket = module.s3_static_hosting.bucket_id
  policy = data.aws_iam_policy_document.s3_allow_cloudfront_access.json
}

