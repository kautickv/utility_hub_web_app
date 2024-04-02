output "bucket_arn" {
  value = aws_s3_bucket.lambda_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
  description = "The name of the S3 bucket"
}

output "bucket_id" {
  value = aws_s3_bucket.lambda_bucket.id
}
output "bucket_regional_domain_name" {
  value = aws_s3_bucket.lambda_bucket.bucket_regional_domain_name
}


