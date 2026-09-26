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

The Backlog section at the end of that file is the to-do list. Start there.

## Read on demand — not auto-loaded
- docs/content.md — site copy and per-item rules (the CV wins on facts; see below).
  Read before writing or changing any copy.
- docs/phase-3-plan.md — Phase 3, done. Diagram rules (tokens, 12px minimum labels,
  mobile stacking) and the deferred Stage 3.4 — read before touching any diagram.
- docs/build-plan.md — Phase 1, done
- docs/phase-2-plan.md — Phase 2, done

## Content rules
- **The CV (`public/cv.pdf`) is the source of truth** for work experience, projects and
  skills. docs/content.md holds site copy and per-item rules; where the two disagree on
  a fact, the CV wins and content.md gets corrected. Never invent projects, employers,
  metrics or skills.
- Nothing about TAC beyond what's already public on the CV. TAC system names only as
  the CV names them (Fineos, Domino). No data, no architecture diagrams of TAC systems.
- Azure and Terraform are project-level experience. Never presented at the same weight
  as production AWS work.
- The AWS Event-Driven Order Platform was built for a client demo. Never name or refer
  to the client anywhere on the site, in the project row or on its deep-dive page.
- Client names ARE allowed on /experience, because they're already public on the CV:
  Dr. Sulaiman Al Habib Medical Group (Cloud Solutions International), Seylan Bank
  (Qbitum Solution).
- Keep React off the site (rusty) unless told otherwise.
- Skills: only what the CV lists. If it isn't on the CV, it doesn't go on the site.

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
- Pushing to `master` deploys. Ask before every push. `gh` isn't installed — check
  Actions runs through the public GitHub API with curl.
- Nalinka usually has `astro dev` running on port 4321. A second dev server can't be
  started from here (Astro's lock file). Verify with `npm run build` and dist/, or
  against 4321 — a new route needs his dev server restarted.

## Settled wording
- Site intro says "a software engineer", even though the CV headline is "Full Stack
  Developer" and the Qbitum title was Senior. Decided 2026-09-27 — the plain wording
  covers it. Don't change it or re-raise it.
