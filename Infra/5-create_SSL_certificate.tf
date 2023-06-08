# Create a new SSL certificate
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = "pass.example.com"
  validation_method         = "DNS"
  tags                      = { Name = "pass.example.com" }
}

# Create new record in route53
resource "aws_route53_record" "cert_records" {
  name    = aws_acm_certificate.ssl_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.ssl_certificate.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.hosted_zone.zone_id
  records = [aws_acm_certificate.ssl_certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.cert_records.fqdn]
}