# Print the bucket id
output "S3_bucket_hosting_id" {
  value = module.s3_static_hosting.bucket_id
}

# Print the bucket website endpoint to terminal
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
}

# Print the CloudFront distribution domain name
output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# Print the invoke URL for /auth/creds on terminal
output "invoke_url" {
  value = aws_api_gateway_stage.utility_hub_api_gateway_stage.invoke_url
}