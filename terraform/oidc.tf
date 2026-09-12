# GitHub Actions OIDC deploy role. GitHub exchanges a short-lived OIDC token for
# temporary AWS credentials at workflow run time — no long-lived AWS access keys
# are stored anywhere (not in the repo, not in repo secrets).

variable "github_repo" {
  description = "GitHub repo allowed to assume the deploy role, in \"org/repo\" form."
  type        = string
  default     = "nalinka1/nalinka-heshan"
}

variable "github_branch" {
  description = "Only this branch may assume the deploy role. Scoped to the branch, not the whole repo."
  type        = string
  default     = "master"
}

# Fetches GitHub's current TLS certificate chain to derive the OIDC provider's
# thumbprint, instead of hardcoding a value that goes stale on cert rotation.
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[length(data.tls_certificate.github_actions.certificates) - 1].sha1_fingerprint]
}

# Trust policy: only workflow runs on var.github_branch in var.github_repo,
# authenticating as the GitHub OIDC audience "sts.amazonaws.com", may assume
# this role. Both conditions are required (StringEquals on both).
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"]
    }
  }
}

resource "aws_iam_role" "github_actions_deploy" {
  name               = "gha-deploy-nalinkaheshan-dev"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
}

# Permissions policy: sync dist/ to the bucket and invalidate the distribution.
# Nothing else — no read access, no other buckets, no other distributions.
data "aws_iam_policy_document" "github_actions_deploy" {
  statement {
    sid       = "SyncSiteObjects"
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }

  statement {
    sid       = "ListBucketForSync"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.site.arn]
  }

  statement {
    sid       = "InvalidateCache"
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.site.arn]
  }
}

resource "aws_iam_role_policy" "github_actions_deploy" {
  name   = "deploy-site"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.github_actions_deploy.json
}
