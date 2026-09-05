# Build Plan

Stage 1 is tonight. Everything below it is optional and can be abandoned at any point
without leaving the site broken.

---

## Stage 0 — Prerequisites (do first, blocks everything)

- [ ] Domain registered and nameservers pointing at a Route 53 hosted zone
- [ ] AWS account you're happy to attach a public domain to
- [ ] GitHub repo created (public — the repo is part of the demonstration)

If the domain isn't sorted, buy it now. ACM validation can't start until DNS is yours,
and propagation is the one thing tonight that you can't speed up.

---

## Stage 1 — Live and deploying (target: tonight)

The goal is an ugly page on a real HTTPS URL, deployed by pushing to main.

### 1.1 Scaffold
- [ ] `npm create astro@latest` — minimal template, TypeScript on
- [ ] One page: name, one-line description, nothing else
- [ ] `npm run build` produces `dist/`
- [ ] Commit and push

### 1.2 Infrastructure as code
Terraform or CDK, your call. Terraform reinforces the multi-cloud project; CDK is faster
given your existing experience. Don't spend more than two minutes choosing.

- [ ] S3 bucket, private, no public access, no website hosting enabled
- [ ] CloudFront distribution with Origin Access Control (not the deprecated OAI)
- [ ] Bucket policy allowing only that distribution
- [ ] ACM certificate **in us-east-1** — required for CloudFront regardless of where the
      rest of the stack lives
- [ ] Route 53 A/AAAA alias records to the distribution
- [ ] Default root object `index.html`
- [ ] 403/404 both mapped to `/index.html` if you want clean routing later

**Checkpoint:** upload a placeholder `index.html` by hand and confirm it loads over HTTPS
on your domain. Do not proceed until this works.

### 1.3 OIDC deploy pipeline
This is the part that makes the site worth showing.

- [ ] GitHub OIDC identity provider in IAM (`token.actions.githubusercontent.com`,
      audience `sts.amazonaws.com`)
- [ ] IAM role with a trust policy scoped to `repo:<user>/<repo>:ref:refs/heads/main` —
      scope it to the branch, not just the repo
- [ ] Permissions: `s3:PutObject`/`DeleteObject` on the bucket,
      `cloudfront:CreateInvalidation` on the distribution. Nothing else.
- [ ] Workflow with `permissions: id-token: write, contents: read`
- [ ] Build → `aws-actions/configure-aws-credentials` with `role-to-assume` → sync → invalidate
- [ ] **No `AWS_ACCESS_KEY_ID` anywhere in the repo or in repo secrets**

**Checkpoint:** push a trivial change to main, watch it appear on the live site.

### Stage 1 done
A page with your name on it, live on your domain, deployed from a push, with zero stored
AWS credentials. Stop here if it's late. This is already a legitimate thing to link.

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
- Any evening spent on this that should have been spent on applications