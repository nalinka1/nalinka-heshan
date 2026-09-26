---
title: "Multi-Cloud Secure Platform, AWS and Azure"
slug: "multi-cloud-secure-document-platform"
summary: "Cross-cloud OIDC workload identity federation so a workload authenticates across clouds with no stored access keys, with negative tests proving expired tokens and wrong identities are denied. Terraform-provisioned landing zone with remote state and locking, custom RBAC roles, and managed identities pulling secrets with no credentials in code."
stack:
  - "Terraform"
  - "Bicep"
  - "AWS CDK"
  - "AWS (S3, KMS, IAM)"
  - "Azure (Entra ID, RBAC, Key Vault)"
  - "GitHub Actions"
  - "OIDC"
status: "in progress"
order: 2
body:
  whatItIs: "A project connecting AWS and Azure so a workload in one cloud can authenticate to the other with no stored access keys. Both sides are provisioned as code, and negative tests prove that the wrong callers are denied."
  built:
    - "Cross-cloud OIDC workload identity federation between AWS and Azure — no stored access keys."
    - "Negative tests proving expired tokens and wrong identities are denied."
    - "A Terraform-provisioned landing zone with remote state and locking."
    - "Custom RBAC roles."
    - "Managed identities pulling secrets, with no credentials in code."
    - "GitHub Actions deploying to both clouds through federated credentials."
---
