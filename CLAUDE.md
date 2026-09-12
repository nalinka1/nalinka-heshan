# CLAUDE.md — Portfolio Site

## What this is
Nalinka Heshan's personal portfolio site at nalinkaheshan.dev. Two jobs: (1) a link on
his CV/LinkedIn that recruiters click, (2) a demonstration piece — the deploy pipeline is
as much the point as the content.

## Priority rule
Job hunt comes first. Ship ugly, ship fast, keep every stage abandonable. No scope creep.

## Stack (decided — do not relitigate)
- **Astro**, static output, minimal JS, TypeScript strict
- **S3 + CloudFront + ACM** — not Amplify, not Vercel, not GitHub Pages. The infra is
  the demonstration.
- **Terraform** for IaC. Not CDK.
- **Cloudflare** for DNS. Not Route 53 — see below.
- **GitHub Actions + OIDC role assumption** — zero long-lived AWS credentials, anywhere.

## DNS — why Cloudflare, not Route 53
The domain is registered through Cloudflare Registrar, whose Domain Registration
Agreement (section 6.1) requires the registrant to use Cloudflare's nameservers and
prohibits changing them. This applies at every plan tier; the Business/Enterprise
"custom nameservers" feature is vanity branding on Cloudflare DNS, not delegation to an
external provider. Route 53 is out of the architecture entirely.

Practical consequences:
- ACM validation record → CNAME added manually in Cloudflare, **proxy OFF (grey cloud)**
- Apex → CloudFront via Cloudflare CNAME flattening, **proxy OFF**
- Proxy must stay off. Orange cloud would put Cloudflare in front of CloudFront,
  terminate TLS with Cloudflare's certificate, and make the ACM cert pointless.
- Terraform does not manage DNS records. Output the ACM validation CNAME and the
  CloudFront distribution domain name so they can be added by hand.

**Both records exist in Cloudflare and are confirmed proxy-off** — the ACM validation
CNAME (added by hand during the Stage 1.2 apply) and the apex CNAME to the CloudFront
domain. The site returns 200 over HTTPS on `nalinkaheshan.dev` itself. Nothing pending
here — don't re-flag or re-investigate either record.

## AWS account constraint
The account has Free Tier restrictions on some services — Route 53 domain registration
returns "Free Tier accounts are not supported for this service". If any Terraform apply
fails with that message, stop and flag it rather than working around it.

## Progress
- **Stage 1.1 — done.** Astro scaffolded (minimal template, TypeScript strict),
  placeholder page with name only, `npm run build` verified, committed and pushed to
  `master`.
- **Stage 1.2 — done.** Terraform for S3, CloudFront, ACM applied; `dist/` synced and
  confirmed on HTTPS on the apex domain `nalinkaheshan.dev` (both Cloudflare records in
  place, proxy off).

## Build order
1. Stage 1: empty page, live on HTTPS, deployed by push to master, OIDC pipeline, no
   stored AWS keys. Nothing else until this works end to end.
2. Stage 2: content (intro, projects, experience, links) — see CONTENT.md, don't invent
   copy.
3. Stage 3: visual polish — one typeface, real colour choice, mobile check, Lighthouse
   pass.
4. Stage 4 (pick at most one): /architecture page, cache headers, staging env, security
   headers.

Explicitly NOT doing: blog, CMS, contact form, visitor counter, analytics, dark mode,
animations beyond subtle polish, chatbot version of the CV.

## Content rules
- All facts come from CONTENT.md / his CV. Never invent projects, employers, metrics.
- Nothing about TAC beyond what's already public on his CV. No internal system names, no
  data, no architecture diagrams of TAC systems.
- Azure and Terraform are project-level experience — label as such, never presented at
  the same weight as production AWS work.
- Keep React off the site (rusty) unless he says otherwise.
- Don't use unconfirmed skills: JUnit, Mockito, Jest, Cypress, SonarQube, Redis, Kinesis,
  Ionic, Graylog.

## Tone for site copy
Plain, specific, first person, short sentences. Banned words: leverage, spearheaded,
seamlessly, robust, cutting-edge, passionate, dynamic, results-driven, "not just X but
Y", "with a focus on". No hero-section slogans.

## Working style
- One checklist item at a time.
- **Plan before applying.** Show the Terraform plan and file structure before creating
  anything. Never run `terraform apply` without explicit approval.
- IAM trust policies and bucket policies get reviewed line by line before they're
  applied.
- Commit at each checkpoint, not one giant commit.
- Flag anything that touches cost (NAT gateways, always-on compute, RDS) before creating
  it — budget is a few dollars a month.
- Interactive CLI wizards hang in this terminal. Use non-interactive flags.

## Debugging playbook
1. AccessDenied on the site → CloudFront OAC not attached, or bucket policy missing the
   distribution ARN condition.
2. ACM cert stuck pending → must be in us-east-1 for CloudFront; check the CNAME resolves
   and that Cloudflare's proxy is off for that record.
3. Actions fails assuming the role → trust policy `sub` condition doesn't match
   repo/branch, or wrong OIDC audience (`sts.amazonaws.com`).
4. Deploy succeeds but site is stale → CloudFront invalidation missing or scoped too
   narrowly.