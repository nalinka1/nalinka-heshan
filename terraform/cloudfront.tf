resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.domain_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Appends index.html to URIs ending in "/" or with no file extension. Needed
# because the S3 origin is private and reached through OAC, not S3 website
# hosting (see s3.tf) — so there's no automatic directory-index resolution for
# anything but the bare "/" request. See functions/append-index-html.js.
resource "aws_cloudfront_function" "append_index_html" {
  name    = "${replace(var.domain_name, ".", "-")}-append-index-html"
  runtime = "cloudfront-js-1.0"
  comment = "Append index.html to extensionless URIs"
  publish = true
  code    = file("${path.module}/functions/append-index-html.js")
}

# AWS-managed cache policy, referenced by name rather than hardcoding its ID.
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name]
  price_class         = var.price_class
  comment             = var.domain_name

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-${aws_s3_bucket.site.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-${aws_s3_bucket.site.id}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.append_index_html.arn
    }
  }

  # SPA-style fallback: both a missing object (403 from a private bucket via
  # OAC — S3 doesn't return 404 for objects it won't even confirm exist) and
  # a genuinely absent path resolve to index.html, so client-side routing
  # (added later, if ever) doesn't 404 on refresh. Served with a real 200 so
  # search engines don't index every path as "not found".
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.site.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
