variable "domain_name" {
  description = "Apex domain the site is served on. DNS is managed in Cloudflare, not here."
  type        = string
  default     = "nalinkaheshan.dev"
}

variable "aws_region" {
  description = <<-EOT
    Single region for everything (bucket + CloudFront's required ACM cert).
    Must be us-east-1: ACM certs used by CloudFront are only recognized in
    us-east-1 regardless of where other resources live, and there's no reason
    for the S3 bucket to be anywhere else for a single small static site.
  EOT
  type        = string
  default     = "us-east-1"
}

variable "price_class" {
  description = <<-EOT
    CloudFront price class. PriceClass_100 = North America + Europe edge
    locations only, cheapest option. A portfolio site for recruiters doesn't
    need global edge coverage. Flagging this as a cost-relevant default —
    change to PriceClass_All if that assumption is wrong.
  EOT
  type        = string
  default     = "PriceClass_100"
}
