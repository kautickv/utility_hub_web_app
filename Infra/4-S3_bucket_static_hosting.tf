#Create bucket to store React build files
resource "aws_s3_bucket" "static_hosting_bucket_name" {
  bucket = "${var.bucket_name}"
  force_destroy = true
  acl = "private"
}

# Configure s3 bucket for static hosting
resource "aws_s3_bucket_website_configuration" "static_hosting_bucket_config" {
    bucket = aws_s3_bucket.static_hosting_bucket_name.id

    index_document {
        suffix = "index.html"
    }

  error_document {
    key = "index.html"
  }
}

# Print the bucket id
output "S3_bucket_hosting_id" {
  value = aws_s3_bucket.static_hosting_bucket_name.id
}

# Print the bucket website endpoint to terminal
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
}