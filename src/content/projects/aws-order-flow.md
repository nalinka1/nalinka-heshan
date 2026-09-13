---
title: "AWS Event-Driven Order Platform"
slug: "aws-order-flow"
summary: "Serverless order flow built with API Gateway, Lambda, DynamoDB, SNS/SQS and S3, provisioned end to end with AWS CDK. Later added a DynamoDB to Aurora PostgreSQL migration with contract tests comparing behaviour before and after the move."
stack:
  - "AWS CDK"
  - "API Gateway"
  - "Lambda"
  - "DynamoDB"
  - "Aurora PostgreSQL"
  - "SNS"
  - "SQS"
  - "S3"
repo: "https://github.com/nalinka1/aws-order-flow"
order: 1
body:
  whatItIs: "A serverless order flow on API Gateway, Lambda, DynamoDB, SNS and SQS, provisioned end to end with AWS CDK across multiple stacks. Later migrated to Aurora PostgreSQL to demonstrate the same flow on a relational backend."
  decisions:
    - decision: "Split the system into multiple CDK stacks instead of one."
      rejected: "A single CDK stack for the whole system."
      why: "So the data layer could be replaced without touching the API or messaging stacks — this is what made the Aurora migration tractable."
    - decision: "Wrote the migration script idempotent and re-runnable."
      rejected: "A one-shot script that needed the target cleaned before every run."
      why: "So a partial run could be repeated safely instead of requiring the target cleaned first."
    - decision: "Used contract tests comparing API responses either side of the cutover."
      rejected: "Verifying only that row counts matched between DynamoDB and Postgres."
      why: "Row counts reconciling wouldn't have caught the representation break that actually surfaced — every consumer parsing those fields would have broken even though the rows and counts matched."
  whatBroke: "The contract tests failed on representation, not data. Timestamps stored as ISO strings in DynamoDB came back from Postgres as epoch numbers. The rows were correct and the counts reconciled, so a data-level check would have passed — but every consumer parsing those fields would have broken. Several similar type mismatches surfaced the same way. All caught before staging."
---
