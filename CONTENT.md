# Site Content — source of truth for copy

Everything here is drawn from the job-hunt knowledge base. Nothing is invented. Edit the
wording freely; don't add facts that aren't here.

---

## Meta

- **Title:** Nalinka Heshan — Software Engineer
- **Description:** Backend and cloud engineer in Geelong, Victoria. Java, Spring Boot,
  Kafka, AWS. Six years building payment, claims and clinical systems.

---

## Intro

Draft — cut it further if it feels long:

> I'm Nalinka, a software engineer in Geelong, Victoria.
>
> I build backend systems where failure costs real money — insurance claims, banking,
> payments, hospital billing. Mostly Java and Spring Boot, Kafka at transactional scale,
> and AWS. Right now I'm working on enterprise claims systems at the Transport Accident
> Commission, mapping a payments platform and its interconnected systems to design the
> integration layer for its replacement.
>
> Outside that I'm building cloud infrastructure projects to go deeper on AWS and Azure.
> This site is one of them — [how it's deployed](/architecture).

Availability line, only if you want it visible:

> My current contract ends in September 2026 and I'm open to backend, integration and
> cloud engineering roles in Melbourne, Geelong, or remote across Australia.

---

## Projects

Three. Ordered by what you most want to be hired for.

### AWS Event-Driven Order Platform
Serverless order flow built with API Gateway, Lambda, DynamoDB, SNS/SQS and S3,
provisioned end to end with AWS CDK. Later added a DynamoDB to Aurora PostgreSQL
migration with contract tests comparing behaviour before and after the move.

`AWS CDK · API Gateway · Lambda · DynamoDB · Aurora PostgreSQL · SNS · SQS · S3`

https://github.com/nalinka1/aws-order-flow

### Multi-Cloud Secure Platform, AWS and Azure
Cross-cloud OIDC workload identity federation so a workload authenticates across clouds
with no stored access keys, with negative tests proving expired tokens and wrong
identities are denied. Terraform-provisioned landing zone with remote state and locking,
custom RBAC roles, and managed identities pulling secrets with no credentials in code.

`Terraform · Bicep · AWS CDK · AWS (S3, KMS, IAM) · Azure (Entra ID, RBAC, Key Vault) · GitHub Actions · OIDC`

> Label this as a project, not production experience. Azure and Terraform are project-only.

### AI-Powered LEGO Sorting System
Computer vision and a CNN classifying LEGO pieces by type in real time. The interesting
part wasn't the model — the first version failed on pieces with no clean training
examples, and accuracy only moved once I stopped tuning the network and fixed the data
pipeline.

`Python · TensorFlow · OpenCV`

### Alternate, if you want a fourth
**99Yards** — React Native mobile app for a textile industry vendor-client platform, with
Spring Boot backend and Firebase/GCP infrastructure. Built remotely for a US client, 2025.

---

## Experience

Compressed. One line each. The CV carries the detail.

**Software Engineer — Transport Accident Commission** · Melbourne, VIC · Dec 2025 – Present
Claims and payments systems for Victoria's transport accident insurer. Integration design
for a platform replacement, a recovery-payments consolidation moving 13,000+ records, and
extensions to the Fineos claims platform.

**Software Engineer — Cloud Solutions International** · Colombo, Sri Lanka · Jul 2023 – Dec 2025
Designed and delivered an outpatient pharmacy billing and payments platform for a major
Middle Eastern private healthcare group. Live two years, $100M+ in annual transactions.
Also built a real-time drug interaction checking service against patient medical history.

**Senior Software Engineer — Qbitum Solution** · Colombo, Sri Lanka · Oct 2022 – Jul 2023
Migrated a Sri Lankan bank's core digital platform onto Red Hat OpenShift, with
Prometheus and Grafana monitoring and load testing to support the production cutover.

**Software Engineer — Zilingo** · Colombo, Sri Lanka · Mar 2020 – Sep 2022
Backend services on Play Framework for an eCommerce marketplace, plus analytics and
reporting systems and a major architectural migration.

> **TAC confidentiality:** keep this at the level already published on the CV. No internal
> system detail beyond naming Fineos and Avanti, no data, no architecture diagrams, no
> screenshots.

---

## Skills

Group them. Be honest about the second group.

**Production:** Java, Spring Boot, Node.js, Angular, TypeScript, Apache Kafka, PostgreSQL,
Oracle, MongoDB, Docker, Kubernetes, Red Hat OpenShift, Jenkins, REST and SOAP web
services, MQ messaging, AWS (Lambda, EC2, S3, RDS, DynamoDB, SNS, SQS, API Gateway, CDK,
CloudFormation)

**Project work:** Terraform, Azure (Entra ID, Key Vault, RBAC, managed identities),
GitHub Actions, OIDC workload identity federation, Python

Leave React off unless you decide otherwise — it's rusty. Leave off anything unconfirmed:
JUnit, Mockito, Jest, Cypress, SonarQube, Redis, Kinesis, Ionic, Graylog.

---

## Certifications

- AWS Certified Developer – Associate (July 2025) —
  https://www.credly.com/badges/7ba4feca-7ce4-42b4-bd64-f7b2566c29ac/public_url
- AWS Certified AI Practitioner (August 2026) —
  https://www.credly.com/badges/9b57afd1-0cce-4883-bf64-7e09df3ddef7/linked_in_profile

---

## Links

- GitHub — github.com/nalinka1
- LinkedIn — linkedin.com/in/nalinka-heshan
- Email — nalinkaheshann@gmail.com
- CV (PDF)

Skip the phone number. Email and LinkedIn are enough on a public page.

---

## /architecture page — built, Stage 4

Live at `/architecture`, linked from the intro's "This site is one of them." Content
matches what's actually deployed, not the rough draft below:

> This site is a static Astro build — plain HTML and CSS, no client-side framework.
> Pushing to `master` triggers a GitHub Actions workflow that builds the site and pushes
> it live.
>
> Infrastructure — S3, CloudFront, ACM, and the IAM role GitHub Actions assumes — is
> defined in Terraform. DNS is Cloudflare, not Route 53: the domain is registered through
> Cloudflare Registrar, whose registration agreement requires Cloudflare's own
> nameservers, so there's no delegating to Route 53. The ACM validation record and the
> apex record are both added by hand in Cloudflare with the proxy off.
>
> There are no AWS access keys stored in the repository or in GitHub secrets. GitHub
> Actions authenticates via a short-lived OIDC token exchanged for temporary credentials
> scoped to one IAM role. The role's trust policy is scoped to this repository and this
> branch — and, since this repo was created after GitHub's 2026-07-15 switch to immutable
> subject claims, the trust policy's `sub` condition matches the ID-qualified form
> (`repo:nalinka1@35029715/nalinka-heshan@1358027744:ref:refs/heads/master`), not the
> plain-name format most OIDC tutorials assume.
>
> The role's permissions cover writing to one S3 bucket and invalidating one CloudFront
> distribution — nothing else.

Links out to the `terraform/` directory and the deploy workflow file on GitHub.

That paragraph is worth more in an interview than any amount of visual design.
