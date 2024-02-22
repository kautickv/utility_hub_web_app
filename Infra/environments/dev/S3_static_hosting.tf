# Create a bucket for hosting the React Application
module "s3_static_hosting" {
    source = "../../modules/s3"

    bucket_name = "utitlityhub.vaisnavsingkautick.com"
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

# Print the bucket id
output "S3_bucket_hosting_id" {
  value = module.s3_static_hosting.bucket_id
}

# Print the bucket website endpoint to terminal
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
}