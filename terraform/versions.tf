terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Local state for now. Deliberate choice: no remote backend (S3+DynamoDB) yet
  # since it's an extra resource to create/cost for a single-operator project.
  # Revisit if/when the OIDC pipeline needs to run `terraform apply` in CI —
  # a GitHub Actions runner has no local state to read.
}
