resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint
    origin_id                = "S3-.${var.bucket_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

     s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_hosting_oai.cloudfront_access_identity_path
    }

  }

  # To enable React routing with CloudFront and S3, add a custom error response for the 
  # 404 "page not found" error. By redirecting the error to the index.html file, React 
  # Router can handle the routing appropriately.
  custom_error_response {
    error_code      = 404
    response_code   = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 300
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-.${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_200"

  restrictions {
    # Only allow North America and Europe
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.default.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}