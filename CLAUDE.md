# CLAUDE.md — Portfolio Site

## What this is
Nalinka Heshan's personal portfolio site. Two jobs: (1) a link on his CV/LinkedIn that
recruiters click, (2) a demonstration piece — the deploy pipeline is as much the point
as the content.

## Priority rule
Job hunt comes first. Ship ugly, ship fast, keep every stage abandonable. No scope creep.

## Stack (decided — don't relitigate)
- **Astro**, static output, minimal JS, TypeScript on
- **S3 + CloudFront + Route 53 + ACM** — not Amplify, not Vercel, not GitHub Pages.
  The infra is the demonstration.
- **GitHub Actions + OIDC role assumption** — zero long-lived AWS credentials, anywhere.
- **Terraform or CDK** for IaC.

## Build order
1. Stage 1 (tonight-scale): empty page, live on HTTPS, deployed by push to main,
   OIDC pipeline, no stored AWS keys. Nothing else until this works end to end.
2. Stage 2: content (intro, projects, experience, links) — see CONTENT.md, don't
   invent copy.
3. Stage 3: visual polish — one typeface, real color choice, mobile check, Lighthouse
   pass.
4. Stage 4 (pick at most one): /architecture page, cache headers, staging env,
   security headers.

Explicitly NOT doing: blog, CMS, contact form, visitor counter, analytics, dark mode,
animations beyond subtle polish, chatbot version of the CV.

## Content rules
- All facts come from CONTENT.md / his CV. Never invent projects, employers, metrics.
- Nothing about TAC beyond what's already public on his CV. No internal system names,
  no data, no architecture diagrams of TAC systems.
- Azure/Terraform = project-level experience, label as such, never presented at the
  same weight as production AWS work.
- Keep React off the site (rusty) unless he says otherwise.
- Don't use unconfirmed skills: JUnit, Mockito, Jest, Cypress, SonarQube, Redis,
  Kinesis, Ionic, Graylog.

## Tone for site copy
Plain, specific, first person, short sentences. Banned words: leverage, spearheaded,
seamlessly, robust, cutting-edge, passionate, dynamic, results-driven, "not just X but
Y", "with a focus on". No hero-section slogans.

## Working style
- One checklist item at a time. Show the plan before executing infra changes
  (IAM trust policies, bucket policies especially).
- Commit at each checkpoint, not one giant commit.
- Flag anything that touches cost (NAT gateways, always-on compute, RDS) before
  creating it — budget is a few dollars/month.

## Debugging playbook
1. AccessDenied on the site → CloudFront OAC not attached, or bucket policy missing
   the distribution ARN condition.
2. ACM cert stuck pending → must be in us-east-1 for CloudFront; check CNAME resolves.
3. Actions fails assuming role → trust policy `sub` condition mismatch, or wrong
   OIDC provider thumbprint/audience (`sts.amazonaws.com`).
4. Deploy succeeds but site stale → CloudFront invalidation missing or too narrow.