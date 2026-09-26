# CLAUDE.md — Portfolio Site

## What this is
Nalinka Heshan's personal portfolio site at nalinkaheshan.dev. Two jobs: (1) a link on
his CV/LinkedIn that recruiters click, (2) a demonstration piece — the deploy pipeline is
as much the point as the content.

## Priority rule
Job hunt comes first. Ship ugly, ship fast, keep every stage abandonable. No scope creep.

## Stack (decided — do not relitigate)
- **Astro**, static output, minimal JS, TypeScript strict
- **S3 + CloudFront + ACM** — not Amplify, not Vercel, not GitHub Pages
- **Terraform** for IaC, local state. Not CDK.
- **Cloudflare** for DNS, not Route 53 — reasoning in docs/architecture-decisions.md
- **GitHub Actions + OIDC role assumption** — zero long-lived AWS credentials, anywhere
- **Plain CSS with custom properties** (`src/styles/tokens.css`) — no Tailwind
- **Astro Content Collections** for project/role copy — no CMS
- **Diagrams are hand-written SVG** using the site's own tokens — not Mermaid, not
  exported images. Detail in docs/phase-3-plan.md.

## Detailed context (loaded every session)
@docs/architecture-decisions.md
@docs/phase-3-plan.md

## History (read on demand — not auto-loaded, ask for these when relevant)
- docs/build-plan.md — Phase 1, done
- docs/phase-2-plan.md — Phase 2, done
- docs/content.md — source of truth for every fact used as site copy

## Content rules
- All facts come from docs/content.md and the CV. Never invent projects, employers,
  metrics or skills.
- Nothing about TAC beyond what's already public on the CV. No internal system names
  beyond Fineos and Avanti, no data, no architecture diagrams of TAC systems — this
  matters more in Phase 3 than any previous phase, since Phase 3 is otherwise all about
  drawing architecture diagrams.
- Azure and Terraform are project-level experience. Never presented at the same weight
  as production AWS work.
- The AWS Event-Driven Order Platform was built for a client demo. Never name or refer
  to the client anywhere on the site, in the project row or on its deep-dive page.
- Client names ARE allowed on /experience, because they're already public on the CV:
  Dr. Sulaiman Al Habib Medical Group (Cloud Solutions International), Seylan Bank
  (Qbitum Solution).
- Keep React off the site (rusty) unless told otherwise.
- Unconfirmed skills — don't use on the site: Jest, SonarQube, Ionic, Graylog.
  (JUnit, Mockito, Cypress, Redis, Kinesis, Elasticsearch, Selenium, Apache Druid and
  Apache Flink are now confirmed on the CV and may be used.)

## Tone for site copy
Plain, specific, first person, short sentences. Banned words: leverage, spearheaded,
seamlessly, robust, cutting-edge, passionate, dynamic, results-driven, "not just X but
Y", "with a focus on". No hero-section slogans.

## Working style
- One checklist item at a time.
- Plan before applying. Show Terraform plans and workflow diffs before creating or
  changing anything. Never run `terraform apply` without explicit approval.
- IAM trust policies and bucket policies get reviewed line by line before they're
  applied.
- Commit at each checkpoint, not one giant commit.
- Flag anything that touches cost (NAT gateways, always-on compute, RDS) before creating
  it — budget is a few dollars a month.
- Interactive CLI wizards hang in this terminal. Use non-interactive flags.

## Open items — flag, don't silently resolve
- CV headline is now "Senior Software Engineer"; the site intro still says "a software
  engineer". Nobody has decided which the site should say. Ask before changing it.
