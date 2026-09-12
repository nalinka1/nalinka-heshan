output "acm_validation_record" {
  description = "CNAME to add in Cloudflare (proxy OFF / grey cloud) for ACM DNS validation."
  value = {
    name  = tolist(aws_acm_certificate.site.domain_validation_options)[0].resource_record_name
    type  = tolist(aws_acm_certificate.site.domain_validation_options)[0].resource_record_type
    value = tolist(aws_acm_certificate.site.domain_validation_options)[0].resource_record_value
  }
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain — CNAME the apex to this in Cloudflare (proxy OFF / grey cloud, CNAME flattening handles the apex)."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  description = "Needed later for the OIDC deploy pipeline's cache invalidation step."
  value       = aws_cloudfront_distribution.site.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.site.id
}

output "github_actions_role_arn" {
  description = "Role ARN for the deploy workflow's role-to-assume input."
  value       = aws_iam_role.github_actions_deploy.arn
}
