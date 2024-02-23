## Assume hosted zone is already created. Just adding in the necessary records

# Add cloudfront distribution domain name as a record.
resource "aws_route53_record" "root-a" {
  
  provider = aws.dns_account # Use DNS Account
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}