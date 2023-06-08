# Create a new route53 zone. Defaults to public zone
resource "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  comment      = "This is my public hosted zone for pass.example.com"
}

# Add cloudfront distribution domain name as a record.
resource "aws_route53_record" "root-a" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
