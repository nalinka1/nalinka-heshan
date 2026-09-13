# Build Plan

Stage 1 is the whole goal. Everything below it is optional and can be abandoned at any
point without leaving the site broken.

---

## Stage 0 — Prerequisites (do first, blocks everything)

- [x] Domain registered — `nalinkaheshan.dev`, via Cloudflare Registrar
- [x] AWS account confirmed
- [x] GitHub repo created — public, the repo is part of the demonstration

**DNS note:** Cloudflare Registrar contractually requires Cloudflare's own nameservers,
so Route 53 is not an option and is out of the architecture. Cloudflare handles DNS only
— records point at CloudFront with the proxy off. See CLAUDE.md for the reasoning.

---

## Stage 1 — Live and deploying

The goal is an ugly page on a real HTTPS URL, deployed by pushing to master.

### 1.1 Scaffold — done
- [x] Astro scaffolded, minimal template, TypeScript strict
- [x] One page: name, one-line description, nothing else
- [x] `npm run build` produces `dist/`
- [x] Committed and pushed

### 1.2 Infrastructure as code
**Terraform.** Decided — don't reopen.

- [x] S3 bucket, private, all public access blocked, no website hosting enabled
- [x] CloudFront distribution with Origin Access Control (not the deprecated OAI)
- [x] Bucket policy allowing only that distribution
- [x] ACM certificate **in us-east-1** — required for CloudFront regardless of where the
      rest of the stack lives
- [x] Default root object `index.html`
- [x] 403/404 both mapped to `/index.html` if you want clean routing later
- [x] Terraform outputs the ACM validation CNAME and the CloudFront domain name

DNS is out of Terraform's scope. Two records go into Cloudflare by hand:
- [x] ACM validation CNAME — **proxy off (grey cloud)**, or validation never completes
- [x] Apex CNAME → CloudFront domain — **proxy off**, CNAME flattening handles the apex

**Checkpoint:** upload a placeholder `index.html` by hand and confirm it loads over HTTPS
on the domain. Do not proceed until this works.

`dist/` synced to S3 and confirmed `200 OK` over HTTPS on the apex domain itself
(`nalinkaheshan.dev`). Both Cloudflare records are in place, proxy off.

### 1.3 OIDC deploy pipeline
This is the part that makes the site worth showing.

- [x] GitHub OIDC identity provider in IAM (`token.actions.githubusercontent.com`,
      audience `sts.amazonaws.com`)
- [x] IAM role with a trust policy scoped to `repo:<user>/<repo>:ref:refs/heads/master` —
      scope it to the branch, not just the repo
- [x] Permissions: `s3:PutObject`/`DeleteObject` on the bucket,
      `cloudfront:CreateInvalidation` on the distribution. Nothing else.
- [x] Workflow with `permissions: id-token: write, contents: read`
- [x] Build → `aws-actions/configure-aws-credentials` with `role-to-assume` → sync →
      invalidate
- [x] **No `AWS_ACCESS_KEY_ID` anywhere in the repo or in repo secrets**

**Checkpoint:** push a trivial change to master, watch it appear on the live site.

### Stage 1 — done
A page with your name on it, live on your domain, deployed from a push, with zero stored
AWS credentials. Stop here if it's late. This is already a legitimate thing to link.

The OIDC pipeline works end to end. Both Cloudflare records are in place, proxy off, and
`nalinkaheshan.dev` returns 200 over HTTPS.

**Phase 2 — see `PHASE_2_PLAN.md`** for design, structure, and the route split that
follows Stage 1. It supersedes Stages 2–4 below.

---

## Stage 2 — Content (next session)

Four sections. No more.

- [ ] **Intro** — who you are, what you build, where you are, whether you're available
- [ ] **Projects** — three, each with a paragraph and a GitHub link
- [ ] **Experience** — compressed. Company, title, dates, one line. The CV carries detail.
- [ ] **Links** — GitHub, LinkedIn, email, CV as a PDF

Copy lives in CONTENT.md. Don't write new copy from scratch.

---

## Stage 3 — Making it look intentional (optional)

- [ ] One typeface, two weights
- [ ] A real colour choice, not default blue
- [ ] Sensible spacing scale
- [ ] Mobile check — recruiters open links on phones
- [ ] Lighthouse pass: aim for 100 on performance, it's free with a static Astro build

---

## Stage 4 — Things that would genuinely add something (pick at most one)

Only after Stages 1–3 are done and you still want to build.

- **A `/uses` or `/architecture` page** describing how the site itself is deployed, with
  the Terraform and workflow linked. Cheap, and it makes the demonstration explicit
  rather than hidden.
- **Cache headers done properly** — long max-age on hashed assets, no-cache on HTML.
  Small, correct, and something most portfolio sites get wrong.
- **A second environment** on a `staging.` subdomain from a `develop` branch. Shows
  pipeline thinking. Doubles the infra to maintain.
- **Security headers** via CloudFront response headers policy — CSP, HSTS, frame options.
  Fits the security-platform angle of your other project.

Explicitly not doing: blog, CMS, contact form, visitor counter, analytics, dark mode,
animations, a chatbot version of your CV.

---

## Failure modes to watch for

- Rewriting the design instead of finishing the deploy
- Adding a blog because a blog seems like what portfolios have
- Building a Lambda for something that doesn't need one
- Turning the Cloudflare proxy on and quietly bypassing the ACM certificate
- Any evening spent on this that should have been spent on applications