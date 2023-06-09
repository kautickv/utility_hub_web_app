# Create a SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider = aws.acm
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Store the DNS Entries
resource "aws_route53_record" "validation" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name = aws_acm_certificate.ssl_certificate.domain_validation_options.0.resource_record_name
  type = aws_acm_certificate.ssl_certificate.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.ssl_certificate.domain_validation_options.0.resource_record_value]
  ttl = "300"
}

# Connects DNS Records with our certificate
resource "aws_acm_certificate_validation" "default" {
  provider = "aws.acm"
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [
    aws_route53_record.validation.fqdn,
  ]
}