# Site Content — source of truth for copy

Everything here is drawn from the CV (Sep 2026 version) and prior job-hunt knowledge.
Nothing is invented. Edit the wording freely; don't add facts that aren't here.

---

## Meta

- **Title:** Nalinka Heshan — Software Engineer
- **Description:** Backend and cloud engineer in Melbourne, Victoria. Java, Spring Boot,
  Kafka, AWS. Six years building payment, claims and clinical systems.

---

## Intro

> I'm Nalinka, a software engineer in Melbourne, Victoria.
>
> I build backend systems where failure costs real money — insurance claims, banking,
> payments, hospital billing. Mostly Java and Spring Boot, Kafka at transactional scale,
> and AWS. Right now I'm working on enterprise claims systems at the Transport Accident
> Commission, mapping a payments platform and its interconnected systems to design the
> integration layer for its replacement.
>
> Outside that I'm building cloud infrastructure projects to go deeper on AWS and Azure.
> This site is one of them.

Availability line:

> Available from October 2026 — Melbourne, Geelong, or remote across Australia.

> **Open item:** the CV headline is now "Senior Software Engineer". The intro above
> still says "a software engineer". Nobody has decided whether to change it — ask before
> touching it.

---

## Projects

Four shown, ordered by what he most wants to be hired for, in-progress work last. A
fifth exists but isn't currently used.

### AWS Event-Driven Order Platform
Serverless order flow built with API Gateway, Lambda, DynamoDB, SNS/SQS and S3,
provisioned end to end with AWS CDK across multiple stacks. Later migrated to Aurora
PostgreSQL to demonstrate the same flow on a relational backend, with an idempotent,
re-runnable upsert script and contract tests comparing API responses either side of the
cutover.

`AWS CDK · API Gateway · Lambda · DynamoDB · Aurora PostgreSQL · SNS · SQS · S3`

https://github.com/nalinka1/aws-order-flow

**Has a deep-dive page** at `/projects/aws-order-flow`. Decisions: multiple CDK stacks
so the data layer could be replaced without touching the API or messaging stacks;
idempotent, re-runnable migration script; contract tests comparing responses, not just
row counts. What broke: the contract tests failed on representation, not data —
timestamps stored as ISO strings in DynamoDB came back from Postgres as epoch numbers.
Rows and counts matched; every consumer parsing those fields would still have broken.
Caught before staging.

> **Built for a client demo. Never name or refer to the client anywhere this project
> appears — row, deep-dive page, or diagram.**

### Multi-Cloud Secure Platform, AWS and Azure
In progress — the CV lists it as "2026, in build". Cross-cloud OIDC workload identity federation so a workload
authenticates across clouds with no stored access keys, with negative tests proving
expired tokens and wrong identities are denied. Terraform-provisioned landing zone with
remote state and locking, custom RBAC roles, and managed identities pulling secrets with
no credentials in code. GitHub Actions deploys both clouds via federated credentials.

`Terraform · Bicep · AWS CDK · AWS (S3, KMS, IAM) · Azure (Entra ID, RBAC, Key Vault) ·
GitHub Actions · OIDC`

> Label as project work, not production experience, regardless of completion status —
> Azure and Terraform are project-level.

**Draft deep-dive page** (`body.draft: true` — local dev only, not live). Hands-on
project, so it uses "What I built" (taken from the facts above) instead of Decisions.
Still needs from Nalinka: what broke, any decisions worth recording, and the repo URL
once the code is pushed (currently local only). Remove `draft` to publish.

### AI-Powered LEGO Sorting System
Computer vision and a CNN classifying LEGO pieces by type in real time. The interesting
part wasn't the model — the first version failed on pieces with no clean training
examples, and accuracy only moved once tuning the network stopped and the data pipeline
got fixed instead.

`Python · TensorFlow · OpenCV`

Not on the current CV, but the site can carry more than the CV — kept here deliberately.
No deep-dive page — Stage 3.6 was cancelled. Built for someone else's startup long ago;
not enough remembered detail to write one without inventing it. Row only.

### Claims Intelligence Assistant — in progress
A question-and-answer tool for insurance claim documents, built on retrieval-augmented
generation over synthetic data. Two rules shape it: every answer cites the document it
came from, and LLM cost is capped per request. I chose pgvector over a separate vector
database so one Postgres instance holds both the claims data and the embeddings. The
scaffolding is done; document ingestion and the cited Q&A pipeline are next.

`Python · FastAPI · Postgres + pgvector · AWS Bedrock · AWS CDK`

Source: the repo README (github.com/nalinka1/claims-intelligence-assistant). As of
2026-09-27 only the scaffold exists — FastAPI `/health`, default CDK stack, local
pgvector compose, Next.js starter. Only claim what's built.

> Portfolio project on synthetic data. Never connect it to TAC or any real claims work
> — the README's "borrowed from real claims work" line stays off the site. No repo link
> until ingestion works (an empty scaffold reads as abandoned). Next.js left off the
> stack line (React stays off the site). Deep-dive page once there's a working pipeline
> and a real "what broke".

### Alternate, not currently used
**99Yards** — React Native mobile app for a textile industry vendor-client platform,
with Spring Boot backend and Firebase/GCP infrastructure. Built remotely for a US
client, 2025.

---

## Experience

Compressed, one line each. The CV carries full detail. All dates and locations below
are from the CV, not any earlier draft.

**Software Engineer — Transport Accident Commission** · Melbourne, VIC ·
Dec 2025 – Present
Claims and payments systems for Victoria's transport accident insurer. Reverse-
engineering 50+ interconnected systems to design the integration layer for a platform
replacement, migrating 13,000+ recovery-claims records with full reconciliation, and
extending the Fineos claims platform.

**Software Engineer — Cloud Solutions International** · Colombo, Sri Lanka ·
Jul 2023 – Dec 2025 (remote from Australia from Jun 2025)
Designed and owned the invoice, billing and payments platform for Dr. Sulaiman Al
Habib Medical Group, the largest private healthcare network in the Middle East. Live
two years, $100M+ in annual transactions, invoice failure rates cut to 0.1%. Also built
a real-time drug interaction checking service against patient medical history.

**Senior Software Engineer — Qbitum Solution** · Colombo, Sri Lanka ·
Oct 2022 – Jul 2023
Migrated Seylan Bank's core digital banking platform onto Red Hat OpenShift, with
Prometheus and Grafana monitoring and load testing to support the production cutover.

**Software Engineer — Zilingo** · Colombo, Sri Lanka · Mar 2020 – Sep 2022
Backend services on Play Framework for a B2B eCommerce marketplace, plus analytics and
reporting systems on Apache Druid and Flink, and a major architectural migration.

> **TAC confidentiality:** keep this at the level already published on the CV. No
> internal system detail beyond the names the CV uses (Fineos, Domino), no data, no architecture
> diagrams, no screenshots. This matters more than usual during Phase 3, which is
> otherwise entirely about drawing architecture diagrams.
>
> **Role deep-dive pages** exist as drafts (`body.draft: true`, local dev only) for all
> four roles, filled from the CV's bullets and stack lines. The optional "Technical
> detail" section is empty everywhere until Nalinka writes it.
>
> **Client names for CSI and Qbitum are fine to use** — they're already public on the
> CV. This is a different rule from the Order Platform project above, whose client
> stays anonymous regardless.

---

## Skills

**Production:** Java, Spring Boot, Node.js, Angular, TypeScript, Apache Kafka,
PostgreSQL, Oracle, MongoDB, Redis, Elasticsearch, Apache Druid, Apache Flink, Docker,
Kubernetes, Red Hat OpenShift, Jenkins, JUnit, Mockito, Cypress, Selenium, REST and SOAP
web services, MQ messaging, AWS (Lambda, EC2, S3, RDS, DynamoDB, Aurora PostgreSQL, SNS,
SQS, API Gateway, CDK, CloudFormation, IoT, IAM, KMS, CloudWatch)

**Project work:** Terraform, Bicep, Azure (Entra ID, Key Vault, RBAC, managed
identities), GitHub Actions, OIDC workload identity federation, Python

Leave React off unless decided otherwise — it's rusty. Still unconfirmed, don't use:
Jest, SonarQube, Ionic, Graylog.

---

## Certifications

- AWS Certified Developer – Associate (July 2025) —
  https://www.credly.com/badges/7ba4feca-7ce4-42b4-bd64-f7b2566c29ac/public_url
- AWS Certified AI Practitioner (August 2026) —
  https://www.credly.com/badges/9b57afd1-0cce-4883-bf64-7e09df3ddef7/linked_in_profile

(AWS Solutions Architect – Associate: mock tests purchased, exam not yet booked — not
listed on the site until it's actually earned.)

---

## Links

- GitHub — github.com/nalinka1
- LinkedIn — linkedin.com/in/nalinka-heshan
- Email — nalinkaheshann@gmail.com
- CV (PDF)

No phone number, no contact page/form. Email and LinkedIn are enough on a public page.

---

## /architecture — content already live

Covers: static Astro build in a private S3 bucket behind CloudFront with Origin Access
Control; push-to-master → GitHub Actions → OIDC → S3 sync → CloudFront invalidation with
no manual step; zero stored AWS access keys, trust policy scoped to repo and branch;
Terraform-defined infrastructure, local state; Cloudflare DNS reasoning (see
docs/architecture-decisions.md); the ID-qualified OIDC subject claim gotcha. Two
diagrams live on the page (deploy pipeline, request path) — see docs/phase-3-plan.md.
