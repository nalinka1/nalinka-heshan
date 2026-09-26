# Architecture decisions and learnings

Settled reasoning and hard platform lessons from building this site. Read before
relitigating any of this.

---

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
- Terraform does not manage DNS records. It outputs the ACM validation CNAME and the
  CloudFront distribution domain name so they can be added by hand.

Both records exist in Cloudflare and are confirmed proxy-off. The site returns 200 over
HTTPS on nalinkaheshan.dev itself. **Nothing pending here — don't re-flag or
re-investigate either record.**

## AWS account constraint

The account has Free Tier restrictions on some services — Route 53 domain registration
returns "Free Tier accounts are not supported for this service". If any Terraform apply
fails with that message, stop and flag it rather than working around it.

## OIDC subject claims are ID-qualified, not just names

GitHub made immutable subject claims the default for repos created after 2026-07-15.
This repo's `sub` embeds the numeric owner and repo IDs, not just their names:

```
repo:nalinka1@35029715/nalinka-heshan@1358027744:ref:refs/heads/master
```

not the plain `repo:nalinka1/nalinka-heshan:ref:refs/heads/master` that most
OIDC/AWS tutorials assume. The trust policy's `sub` condition (`terraform/oidc.tf`)
must match the ID-qualified form or role assumption fails with "Not authorized to
perform sts:AssumeRoleWithWebIdentity" even though `aud` is correct. Confirmed by
decoding the actual token in a live workflow run — don't assume the plain-name
format when writing or debugging this condition.

## CloudFront Function for directory indexes

S3, not configured as a website endpoint, won't serve `/path/index.html` for a request
to `/path`. A CloudFront Function rewrites `/path` to `/path/index.html` on every viewer
request, before the cache lookup. This is why every route works cleanly with no public
bucket access and no S3 website-hosting feature enabled. Diagrammed on `/architecture`.

## Invalidation paths — CloudFront only allows a trailing wildcard

`--paths "/*.html"` looks like it should scope invalidation to HTML files, but
CloudFront only accepts `*` at the end of a path, not mid-path. It silently won't match
`/architecture/index.html`. Use `/*` — it's one path against the free monthly quota of
1,000, and correctness is worth more than the saving.

## Debugging playbook

1. **AccessDenied on the site** → CloudFront OAC not attached, or bucket policy missing
   the distribution ARN condition.
2. **ACM cert stuck pending** → must be in us-east-1 for CloudFront; check the CNAME
   resolves and that Cloudflare's proxy is off for that record.
3. **Actions fails assuming the role** → trust policy `sub` condition doesn't match the
   ID-qualified repo/branch form above, or wrong OIDC audience (`sts.amazonaws.com`).
4. **Deploy succeeds but site is stale** → CloudFront invalidation missing, or scoped
   with a mid-path wildcard CloudFront won't accept.

## Pipeline (current)

Three `aws s3 sync --delete` passes, in this order, each with `--delete` scoped to its
own filter so removed files are still cleaned up:

1. `_astro/*` — content-hashed by Vite → `cache-control: public, max-age=31536000,
   immutable`
2. Everything else that isn't HTML and isn't `_astro/*` (favicon, `cv.pdf`) — `cv.pdf`
   gets `no-cache` specifically, since it isn't fingerprinted but does get updated
3. `*.html` last, after the assets it references exist → `cache-control: no-cache`

Then `aws cloudfront create-invalidation --paths "/*"`.

---

## Progress log

- **Phase 1 — done.** Empty page live on HTTPS, deployed by push to `master`, OIDC
  pipeline, zero stored AWS credentials.
- **Phase 2 — done.** Five routes (`/`, `/projects`, `/projects/[slug]`, `/experience`,
  `/architecture`, plus `/cv`), Astro Content Collections, one project deep-dive (AWS
  Event-Driven Order Platform), `/architecture` written up, cache-control split,
  `noindex` on `/cv`. See docs/phase-2-plan.md.
- **Phase 3 — done** (3.4 deferred, 3.6 cancelled). See docs/phase-3-plan.md.
  - 3.0 done — View Transitions removed (so "no client-side framework" on
    `/architecture` stays true), `cv.pdf` cache-control fixed, footer rule alignment
    fixed.
  - 3.1 done — `Diagram.astro` wrapper, diagram-specific tokens.
  - 3.2 done — deploy pipeline diagram on `/architecture`, stacked mobile variant,
    accent path covering the credential-exchange boxes.
  - 3.3 done — request path diagram on `/architecture` (CloudFront Function rewrite,
    OAC, private bucket), accent widened to match its caption (full viewer-to-bucket
    trust path).
  - 3.4 deferred — order platform fanout diagram. SNS-to-three-SQS-queues is a
    parallel relationship; stacking it vertically for mobile would make it read as
    sequential, which is false. Split into two diagrams when it returns: the linear
    path, then the fanout separately.
  - 3.5 done — optional `images` on projects, rendered with Astro `<Image />` (WebP,
    srcset, lazy) on deep-dive pages only. No project uses it yet.
  - 3.6 cancelled — LEGO deep-dive page. Someone else's startup project, not enough
    remembered detail to write it without inventing facts. Row stays on `/projects`.
- **Deep-dive templates — done, content pending.** Every project and role can have a
  deep-dive page. Project pages: only "What it is" required; "What I built", Decisions
  and What broke optional. Role pages (`/experience/[slug]`): only "The role"
  required; "What I worked on", "Technical detail" and Stack optional. `body.draft:
  true` builds a page under `astro dev` only (`src/lib/published.ts`), so placeholder
  content never reaches the live site. Multi-Cloud and all four roles were
  published 2026-09-27 from CV content; more detail to come from Nalinka. Role pages
  stay inside what the CV already says publicly. TAC in particular: system names only
  as the CV names them, no architecture diagrams.

---

## Backlog

Not started. One at a time, in roughly this order.

- **Real 404 page.** `terraform/cloudfront.tf` maps both 403 and 404 to `/index.html`
  with a 200 — an SPA fallback for client-side routing the site doesn't have. Every
  mistyped or dead URL serves the home page as a 200 (a soft 404), so broken links are
  invisible and search engines can index junk paths. Fix: add `src/pages/404.astro`
  (Astro emits `404.html`), then change both `custom_error_response` blocks to
  `response_code = 404`, `response_page_path = "/404.html"`. Terraform change — show
  the plan before apply. Check the CloudFront Function doesn't rewrite `/404.html`,
  and that `/404.html` gets `no-cache` like other HTML.
- **`@astrojs/check` in CI.** Carried over from Stage 3.0. Workflow diff before change.
- **Stage 3.4 — order platform diagrams.** Deferred; see docs/phase-3-plan.md.
- **Content from Nalinka.** "Technical detail" for each role page; what broke,
  decisions and repo URL for Multi-Cloud.
