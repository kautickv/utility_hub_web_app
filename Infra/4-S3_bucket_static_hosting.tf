#Create bucket to store React build files
resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
  force_destroy = true
}

# Create and assign a bucket policy to unblock all public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "static_hosting_bucket_name" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure s3 bucket for static hosting
resource "aws_s3_bucket_website_configuration" "static_hosting_bucket_config" {
    bucket = aws_s3_bucket.static_hosting_bucket_name.id

    index_document {
        suffix = "index.html"
    }

  error_document {
    key = "error.html"
  }
}

#Create a json object for s3 bucket policy to make bucket public
data "aws_iam_policy_document" "s3_read_permissions" {
  statement {
    sid = "AllowPublicReadAccess"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = ["${aws_s3_bucket.static_hosting_bucket_name.arn}",
                 "${aws_s3_bucket.static_hosting_bucket_name.arn}/*"
    ]
  }
}

# Assign the above policy to s3 static hosting bucket
resource "aws_s3_bucket_policy" "s3_allow_public_access" {
  bucket = aws_s3_bucket.static_hosting_bucket_name.id
  policy = data.aws_iam_policy_document.s3_read_permissions.json
}

# Upload build folder inside s3
resource "aws_s3_object" "build_upload"{
    for_each = fileset("../${path.module}/front_end/build/", "**")
    bucket = aws_s3_bucket.static_hosting_bucket_name.id
    key = each.value
    source = "../${path.module}/front_end/build/${each.value}"
    etag = filemd5("../${path.module}/front_end/build/${each.value}")
    metadata = {
        Content-Type: "text/html"
    }
}

# Print the bucket website endpoint to terminal
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
}