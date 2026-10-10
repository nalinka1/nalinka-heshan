---
title: "Multi-Cloud Secure Document Platform, AWS and Azure"
slug: "multi-cloud-secure-document-platform"
summary: "Cross-cloud OIDC workload identity federation, so a workload in Azure reads an encrypted S3 bucket with no AWS access key anywhere on the Azure side. Four negative tests prove the boundaries hold: a wrong identity, an expired token, an out-of-scope prefix and a missing KMS grant are each denied. Both clouds provisioned from one Terraform configuration with remote state and blob-lease locking."
stack:
  - "Terraform"
  - "AWS (S3, KMS, IAM, STS)"
  - "Azure (Entra ID, RBAC, Key Vault, API Management, VNet)"
  - "OIDC"
status: "in progress"
order: 2
body:
  whatItIs: "A build that answers one question: how does a workload in one cloud authenticate to storage in another without an access key sitting in a config file?\n\nThe answer is OIDC workload identity federation. Everything else in the project exists to make that answer defensible - a storage layer worth protecting, two API tiers with genuinely different threat models, and negative tests that prove the boundaries rather than assuming them."
  built:
    - "Cross-cloud OIDC workload identity federation. An Azure managed identity gets a token from Entra ID and exchanges it at AWS STS for short-lived credentials. No AWS key is stored on the Azure side."
    - "A trust policy that does real work. Conditioned on the audience and subject claims, with the issuer pinned structurally by which OIDC provider is named. The federated role can read one S3 prefix, list only that prefix, and decrypt with one key."
    - "Four negative tests, all denied. A different managed identity is refused at STS; expired credentials return ExpiredToken; a read outside the permitted prefix is refused at S3; and removing kms:Decrypt breaks the read even with s3:GetObject intact."
    - "An S3 store with two independent authorisation gates. SSE-KMS with a customer-managed key, versioning, all four public access blocks, and a bucket policy with three explicit denies - unencrypted uploads, uploads under the wrong key, and plain HTTP."
    - "Two Azure API Management tiers with different security models. The external tier validates JWTs against Entra ID - issuer, audience and a required app role. The internal tier is VNet-injected and reaches Key Vault with its own system-assigned managed identity, so no secret exists in the policy."
    - "One Terraform configuration across both clouds, with remote state in an Azure Storage blob, lease-based locking, and hand-built resources brought under management by terraform import."
---
