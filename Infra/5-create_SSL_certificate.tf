# Create a new SSL certificate
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
}

# Create new record in route53
resource "aws_route53_record" "cert_records" {
  for_each = toset([for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.resource_record_name])

  name    = aws_acm_certificate.ssl_certificate.domain_validation_options[each.key].resource_record_name
  type    = aws_acm_certificate.ssl_certificate.domain_validation_options[each.key].resource_record_type
  zone_id = aws_route53_zone.hosted_zone.zone_id
  records = [aws_acm_certificate.ssl_certificate.domain_validation_options[each.key].resource_record_value]
  ttl     = 60
}

# Validate the certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_records : record.fqdn]
}
