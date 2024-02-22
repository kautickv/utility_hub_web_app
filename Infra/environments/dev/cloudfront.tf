# Create a Cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "static_hosting_oai" {
  comment = "Access identity for static hosting"
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
  bucket = aws_s3_bucket.static_hosting_bucket_name.id
  policy = data.aws_iam_policy_document.s3_allow_cloudfront_access.json
}
