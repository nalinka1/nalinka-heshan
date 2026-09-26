# Phase 3 — Diagrams and images

Phase 2 shipped: five routes, content collections, one project deep-dive, `/architecture`,
cache headers. The site reads well and says true things.

What it can't do yet is show anything. Phase 3 fixes that. Same rules: one stage at a
time, every stage leaves the site working, abandon at any point.

---

## Decisions (made — do not reopen)

- **Diagrams are hand-written SVG**, committed to the repo, using the existing tokens.
  Not Mermaid, not exported PNGs from Excalidraw or draw.io.

  Mermaid's default styling is instantly recognisable and would fight the design system.
  Exported images are binary blobs that can't be diffed, go stale silently, and look
  pasted in from a different site. Hand-written SVG inherits `--ink`, `--rule`, `--muted`
  and `--accent` directly, scales without artefacts, adds no build step and no JS, and
  diffs like code — which matters on a site whose pitch is that the infrastructure is
  hand-built rather than clicked together.

- **Diagrams live in `src/components/diagrams/`** as `.astro` components, one per
  diagram, imported where needed. Not inlined into page markup.

- **Every diagram has a text alternative.** A `<title>` and `<desc>` inside the SVG, plus
  the surrounding prose carrying the same information. The diagram supplements the text;
  it never carries a fact that only exists in the picture.

- **Project images appear on deep-dive pages only.** Not in the rows on `/` or
  `/projects`. Thumbnails in rows turn a clean reference table into a gallery, and two of
  the three projects have nothing photogenic to put there.

- **Astro's `<Image />` for raster images.** WebP, explicit width and height, lazy below
  the fold.

---

## What gets a diagram

Two in this phase. A third is described but deferred — see Stage 3.4.

### 1. Deploy pipeline — `/architecture` — done (Stage 3.2)

Left to right: push to `master` → GitHub Actions → OIDC token request → STS
AssumeRoleWithWebIdentity (merged with temporary credentials into one box) → S3 sync →
CloudFront invalidation → viewer. Cloudflare sits off to the side resolving DNS,
deliberately not in the request path.

Accent path covers the credential-exchange boxes, making "no stored credentials
anywhere" visible rather than just stated in prose.

### 2. Request path — `/architecture` — done (Stage 3.3)

Viewer request → CloudFront Function (`/path` → `/path/index.html`) → CloudFront cache
lookup → Origin Access Control → private S3 bucket.

Accent covers the full viewer-to-bucket trust path (viewer request, cache lookup, OAC,
bucket), matching the caption. The CloudFront Function box stays in `--ink` — it's the
rewrite step, not part of the trust chain.

### 3. Order platform — `/projects/aws-order-flow` — deferred (Stage 3.4)

API Gateway → Lambda → DynamoDB, with SNS/SQS fanout. Then the same diagram with Aurora
PostgreSQL substituted for DynamoDB, showing the swap the multi-stack CDK split made
possible.

**The fanout doesn't stack.** SNS to three SQS queues is a parallel relationship, and
parallel reads horizontally. Rotate it to vertical for mobile and the queues look
sequential — queue two after queue one — which is the diagram asserting something false
about the architecture. That's not a styling problem.

When it comes back, split it into two diagrams rather than solving the rotation: the
linear path (API Gateway → Lambda → data layer), and separately the fanout. Each stacks
cleanly alone, and it lets the data-layer swap — the actual story on that page — be the
diagram shown twice, DynamoDB then Aurora.

---

## What gets a photo

Be honest about this. Two of three projects have nothing to show.

- **LEGO sorting** — the only project with genuine visual material. Pieces being
  classified, the rig, a confusion matrix, before-and-after on the data pipeline fix.
  Its deep-dive page (Stage 3.6) was cancelled — see below.
- **Order platform** — nothing photogenic. The diagram is the visual.
- **Multi-Cloud** — nothing photogenic. Terraform output and denied-access test results
  are text, and belong in the prose.

Don't manufacture screenshots of terminal output to fill space. An architecture diagram
earns its place; a screenshot of `terraform apply` scrolling past does not.

---

## Stages

### Stage 3.0 — Carry-over fixes from Phase 2 — done

- `/architecture` claimed "plain HTML and CSS, no client-side framework" while View
  Transitions had added `ClientRouter`. **Resolved: View Transitions removed**, so the
  sentence is true again.
- `cv.pdf` had no cache-control and isn't fingerprinted — **fixed: `no-cache`** added in
  the workflow.
- Footer rule alignment with the content rule above it — **fixed**.
- `@astrojs/check` in CI — **not done, still open**, low priority.

### Stage 3.1 — Diagram foundations — done

- `src/components/diagrams/Diagram.astro` — shared wrapper handling viewBox,
  `role="img"`, `<title>`/`<desc>`, caption, responsive sizing.
- Diagram tokens added to `tokens.css` where needed — box fill, stroke weight, arrow
  head.

Constraints in force for every diagram: `--ink` for strokes and labels, `--rule` for
secondary lines, `--accent` for the one path that matters, `--muted` for annotations. No
fills beyond `--paper`. No shadows, no gradients, no rounded corners above 4px. Labels in
IBM Plex Sans; AWS resource names and ARNs in IBM Plex Mono. **Minimum 12px labels** —
the first pass on 3.2 shipped at ~8–9px and had to be redone.

### Stage 3.2 — Deploy pipeline diagram — done

Section 1 above. Shipped, reviewed, pushed.

### Stage 3.3 — Request path diagram — done

Section 2 above. Shipped, reviewed, accent widened to match its caption, pushed.

### Stage 3.4 — Order platform diagram — deferred

Section 3 above. Do not attempt the vertical-stack version of the fanout — read the
reasoning above first.

### Stage 3.5 — Image support — done

- Extend the projects schema: optional `images` array, each with `src`, `alt`, `caption`
- Astro `<Image />`, WebP, explicit dimensions, lazy below the fold
- Render on deep-dive pages only
- Source images live in `src/assets/projects/`, not `public/`, so Astro optimises them

Shipped as plumbing only — no project has images yet. Images render under "What it is"
with a 480/960/1920w WebP srcset; an empty `alt` fails the build. `src/assets/projects/`
doesn't exist until the first real image arrives. If a page needs an image in "What
broke" instead, add a per-image section field then, not before.

### Stage 3.6 — LEGO deep-dive page — cancelled

Cancelled 2026-09-27. The project was built for someone else's startup a long time ago;
there isn't enough remembered detail to write decisions and a failure story without
inventing them, and the work isn't Nalinka's to document in depth. The LEGO row stays
on `/projects` with its existing one-paragraph summary, no deep-dive page.

---

## Mobile

Both diagrams in this phase are linear, so both got a **stacked vertical variant below
700px** — the flow runs top to bottom, arrows point down, relationships unchanged. A
second viewBox layout per diagram, roughly twenty lines of SVG each. This is the only
option where a phone user gets the real diagram rather than a degraded one.

Horizontal scroll is the fallback for anything that can't stack, but it costs real
comprehension — scrollable regions get missed, and a recruiter who doesn't realise they
can swipe sees half a picture. Nothing shipped in this phase needs it. The deferred
fanout diagram (Stage 3.4) is the first candidate for it, once it's split as described
above.

Don't shrink to fit. Minimum 12px labels. A diagram that technically fits looks fine in
DevTools and is unreadable in a hand.

---

## Rules that still apply

- Facts come from docs/content.md and the CV. Never invent projects, employers or
  metrics.
- Nothing about TAC beyond what's already public on the CV. **No architecture diagrams
  of TAC systems** — this rule matters more in this phase than any previous one.
- No client names on project pages — see docs/content.md for which client names are and
  aren't allowed where.
- Azure and Terraform are project-level, never at the same weight as production AWS
  work.
- Plain, specific, first person, short sentences. No hero slogan.

---

## Failure modes for this phase

- Building both diagrams before checking whether the first one looks right
- A diagram that carries a fact the prose doesn't
- Screenshots of terminal output used as filler
- Diagrams that shrink illegibly on mobile instead of stacking
- Drawing the order platform fanout vertically, so parallel queues read as sequential
- Reaching for Mermaid or draw.io halfway through because hand-written SVG felt slow
- Any diagram of a TAC system
