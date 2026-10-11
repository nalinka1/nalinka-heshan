# Site Content - source of truth for copy

Everything here is drawn from the CV (11 Oct 2026 version) and prior job-hunt knowledge.
Nothing is invented. Edit the wording freely; don't add facts that aren't here.

---

## Meta

- **Title:** Nalinka Heshan - Software Engineer
- **Description:** Backend and cloud engineer in Melbourne, Victoria. Java, Spring Boot,
  Kafka, AWS. Six years building payment, claims and clinical systems.

---

## Intro

> I'm Nalinka, a software engineer in Melbourne, Victoria.
>
> I build backend systems where failure costs real money - insurance claims, banking,
> payments, hospital billing. Mostly Java and Spring Boot, Kafka at transactional scale,
> and AWS. Right now I'm at the Transport Accident Commission, reverse-engineering 50+
> interconnected systems to design the integration layer for its next claims platform.
>
> Outside that I'm building cloud infrastructure projects to go deeper on AWS and Azure.
> This site is one of them.

Availability line:

> Available with two weeks' notice - Melbourne, or anywhere in Australia.

Changed 2026-10-11: his current contract was extended to the end of January 2027, on
two weeks' notice. The extension itself isn't mentioned on the site.

> The CV headline is "Senior Software Engineer". The intro still says "a software
> engineer" - that's settled (see CLAUDE.md), don't change it.

---

## Projects

Five shown, ordered by what he most wants to be hired for. One more exists but isn't
currently used.

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
row counts. What broke: the contract tests failed on representation, not data -
timestamps stored as ISO strings in DynamoDB came back from Postgres as epoch numbers.
Rows and counts matched; every consumer parsing those fields would still have broken.
Caught before staging.

> **Built for a client demo. Never name or refer to the client anywhere this project
> appears - row, deep-dive page, or diagram.**

### Multi-Cloud Secure Document Platform, AWS and Azure
Done - no "In progress" tag (Nalinka, 2026-10-10). The CV still lists it as "2026, in
build"; that's the CV to correct. Cross-cloud OIDC workload identity
federation, so a workload in Azure reads an encrypted S3 bucket with no AWS access key
anywhere on the Azure side. Four negative tests prove the boundaries hold: a wrong
identity, an expired token, an out-of-scope prefix and a missing KMS grant are each
denied. Both clouds provisioned from one Terraform configuration with remote state and
blob-lease locking.

`Terraform · AWS (S3, KMS, IAM, STS) · Azure (Entra ID, RBAC, Key Vault, API Management,
VNet) · OIDC`

https://github.com/nalinka1/multi-cloud-secure-document-platform

> Label as project work, not production experience, regardless of completion status -
> Azure and Terraform are project-level.

> **Copy rewritten 2026-10-10 from a review of the repo, and here the repo wins over
> the CV.** The CV entry still lists Bicep, AWS CDK and GitHub Actions and calls it a
> "landing zone" with custom RBAC roles. None of that is in the repo (no `.github/`, no
> workflow, no second OIDC provider), so none of it goes on the site. Don't add it back
> from the CV - the CV entry is what needs correcting.

**Has a deep-dive page** (published 2026-09-27, rewritten 2026-10-10). Hands-on
project, so it uses "What I built" instead of Decisions. Diagrams via
`MultiCloud.astro` - see docs/phase-3-plan.md. Still to add from Nalinka: what broke
and any decisions worth recording.

### Casual Services Invoice Automation
Added 2026-10-11. Nalinka's own monthly invoicing: a scheduled Lambda works out
billable days for two sites, fills five fields in his existing PDF template and leaves
a Gmail draft. It never sends. Copy is in
`src/content/projects/casual-services-invoice-automation.md`, row plus deep-dive page.

`Python · AWS (Lambda, EventBridge Scheduler, DynamoDB, S3, Secrets Manager, SNS, SQS,
CloudWatch) · CloudFormation · Gmail API`

Source: the repo's README.md and docs/ARCHITECTURE.md, pasted by Nalinka 2026-10-11
(October 2026 acceptance milestone). Only claim what those say is implemented - the
"Implemented versus proposed" table is the boundary.

**Has diagrams** via `InvoiceAutomation.astro` - see docs/phase-3-plan.md.

> Not an AI project - it's deterministic. Don't describe it as AI or an agent.
> Repo is public since 2026-10-11: https://github.com/nalinka1/casual-invoice-automation
> Don't say it has been running in production. At the milestone the schedules were
> enabled and an isolated end-to-end run had passed, but the first recurring monthly
> run hadn't happened. Update once it has.
> Keep the personal detail out: no site names, no rates, no employer or customer, no
> named regional holidays. "Two sites" is as specific as it gets.
> On the CV since the 11 Oct 2026 version.

### Agent Failure Lab
Added 2026-10-11. A hand-written tool-calling agent over three-way invoice matching,
run fifty times to count how it fails. Copy is in `src/content/projects/agent-lab.md`,
row plus deep-dive page.

`Python · OpenAI API (tool calling)`

https://github.com/nalinka1/agent-lab

Source: the public repo's README.md and FINDINGS.md, reviewed 2026-10-11. Every number
on the site (44/50 correct, 4/50 false approvals, about four cents, two days) is from
FINDINGS.md - don't round them up or add new ones.

**Has diagrams** via `AgentLab.astro` - see docs/phase-3-plan.md.

> It's an experiment, not an automation product: synthetic fixtures, nothing deployed,
> two days of work. Never describe it as an invoice approval system in use.
> On the CV since the 11 Oct 2026 version.

### AI-Powered LEGO Sorting System
Computer vision and a CNN classifying LEGO pieces by type in real time. The interesting
part wasn't the model - the first version failed on pieces with no clean training
examples, and accuracy only moved once tuning the network stopped and the data pipeline
got fixed instead.

`Python · TensorFlow · OpenCV`

Not on the current CV, but the site can carry more than the CV - kept here deliberately.
No deep-dive page - Stage 3.6 was cancelled. Built for someone else's startup long ago;
not enough remembered detail to write one without inventing it. Row only.

### Claims Intelligence Assistant - removed
Removed from the site 2026-10-11 - Nalinka gave up on the project. Don't add it back.

### Alternate, not currently used
**99Yards** - React Native mobile app for a textile industry vendor-client platform,
with Spring Boot backend and Firebase/GCP infrastructure. Built remotely for a US
client, 2025.

---

## Experience

Compressed, one line each. The CV carries full detail. All dates and locations below
are from the CV, not any earlier draft.

**Software Engineer - Transport Accident Commission** · Melbourne, VIC ·
Dec 2025 - Present
Claims and payments systems for Victoria's transport accident insurer. Reverse-
engineering 50+ interconnected systems to design the integration layer for a claims
platform replacement, migrating 13,000+ recovery-claims records so a legacy platform
could be retired, and extending the Fineos claims platform.

> The 11 Oct 2026 CV says "13,000+ recovery-claims records ... allowing the legacy
> platform to be retired". The role page follows its four TAC bullets. Two things came
> off the CV in that version and off the site with it: the Domino documentation bullet
> and the document-extraction batch jobs. Don't add them back. Fineos stays at
> Nalinka's say-so even though the CV doesn't mention it.

**Software Engineer - Cloud Solutions International** · Colombo, Sri Lanka ·
Jul 2023 - Dec 2025 (remote from Australia from Jun 2025)
Designed and owned the invoice, billing and payments platform for Dr. Sulaiman Al
Habib Medical Group, the largest private healthcare network in the Middle East. Live
two years, USD 100M+ in annual transactions (always "USD", as the CV has it), invoice failure rates cut to 0.1%. Also built
a real-time drug interaction checking service against patient medical history.

**Senior Software Engineer - Qbitum Solution** · Colombo, Sri Lanka ·
Oct 2022 - Jul 2023
Migrated Seylan Bank's core digital banking platform onto Red Hat OpenShift, with
Prometheus and Grafana monitoring and load testing to support the production cutover.

**Software Engineer - Zilingo** · Colombo, Sri Lanka · Mar 2020 - Sep 2022
Backend services on Play Framework for a B2B eCommerce marketplace, plus analytics and
reporting systems on Apache Druid and Flink, and a major architectural migration.

> **TAC confidentiality:** keep this at the level already published on the CV. No
> internal system detail beyond the names the CV uses (Fineos, Domino), no data, no architecture
> diagrams, no screenshots. This matters more than usual during Phase 3, which is
> otherwise entirely about drawing architecture diagrams.
>
> **Role deep-dive pages** are published (2026-09-27) for all four roles, filled from
> the CV's bullets and stack lines. The optional "Technical
> detail" section is empty everywhere until Nalinka writes it.
>
> **Client names for CSI and Qbitum are fine to use** - they're already public on the
> CV. This is a different rule from the Order Platform project above, whose client
> stays anonymous regardless.

---

## Skills

The site has no skills section. If one is ever added, take it from the CV's Technical
Skills block (11 Oct 2026 version) and nothing else. That version no longer lists
Bicep or an Azure line - Azure appears only in the Multi-Cloud project entry.

Leave React off unless decided otherwise - it's rusty. Still unconfirmed, don't use:
Jest, SonarQube, Ionic, Graylog.

---

## Certifications

On the home page, after Projects (added 2026-10-10): details on the left, the Credly
badge image on the right, from `src/assets/images/`. Credly's per-badge skill lists
are left off - Bedrock and SageMaker aren't on the CV.

- AWS Certified Developer - Associate - issued Jul 2025, expires Jul 2028 -
  https://www.credly.com/badges/7ba4feca-7ce4-42b4-bd64-f7b2566c29ac/linked_in_profile
- AWS Certified AI Practitioner - issued Aug 2026, expires Aug 2029 -
  https://www.credly.com/badges/9b57afd1-0cce-4883-bf64-7e09df3ddef7/linked_in_profile

(AWS Solutions Architect - Associate: mock tests purchased, exam not yet booked - not
listed on the site until it's actually earned.)

---

## Links

- GitHub - github.com/nalinka1
- LinkedIn - linkedin.com/in/nalinka-heshan
- Email - nalinkaheshann@gmail.com
- CV (PDF)

No phone number, no contact page/form. Email and LinkedIn are enough on a public page.

---

## /architecture - content already live

Covers: static Astro build in a private S3 bucket behind CloudFront with Origin Access
Control; push-to-master → GitHub Actions → OIDC → S3 sync → CloudFront invalidation with
no manual step; zero stored AWS access keys, trust policy scoped to repo and branch;
Terraform-defined infrastructure, local state; Cloudflare DNS reasoning (see
docs/architecture-decisions.md); the ID-qualified OIDC subject claim gotcha. Two
diagrams live on the page (deploy pipeline, request path) - see docs/phase-3-plan.md.
