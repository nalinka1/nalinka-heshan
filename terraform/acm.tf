# DNS is Cloudflare's, not Terraform's (see CLAUDE.md). This resource only
# creates the certificate request and exposes the validation CNAME as an
# output — it does NOT create any DNS record.
resource "aws_acm_certificate" "site" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Polls the ACM API until the cert shows ISSUED. It does not create or depend
# on a Route 53 record — it just waits. In practice this means `terraform
# apply` will block here after the certificate resource is created, until
# the validation CNAME (see outputs.tf) is added by hand in Cloudflare with
# the proxy off and has propagated. That's expected, not a hang to work
# around.
resource "aws_acm_certificate_validation" "site" {
  certificate_arn = aws_acm_certificate.site.arn

  validation_record_fqdns = [
    for opt in aws_acm_certificate.site.domain_validation_options : opt.resource_record_name
  ]
}
