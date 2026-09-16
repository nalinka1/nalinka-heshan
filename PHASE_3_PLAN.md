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

Two in this phase. The third is described but deferred — see Stage 3.4.

### 1. Deploy pipeline — `/architecture`

The most valuable diagram on the site. The page currently describes in seven paragraphs a
flow that draws in about eight boxes.

Left to right: push to `master` → GitHub Actions → OIDC token request → STS → temporary
credentials → S3 sync → CloudFront invalidation → viewer. Cloudflare sits off to the side
resolving DNS, deliberately not in the request path.

The one thing the diagram must make visible that prose struggles with: **no stored
credentials anywhere**. Mark the token exchange path distinctly — it's the whole point of
the architecture.

### 2. Request path — `/architecture`

Smaller, four boxes. Viewer → CloudFront → OAC → private S3 bucket, with the CloudFront
Function rewriting `/path` → `/path/index.html` on viewer request.

Worth its own diagram because the directory-index problem is the kind of detail that reads
as real experience. Anyone who has served a static site from a private OAC-backed bucket
has hit it.

### 3. Order platform — `/projects/aws-order-flow`

API Gateway → Lambda → DynamoDB, with SNS/SQS fanout. Then the same diagram with Aurora
PostgreSQL substituted for DynamoDB, showing the swap the multi-stack CDK split made
possible.

Two states of one diagram is more convincing than two separate pictures. If that proves
fiddly, one diagram with the data layer boxed and labelled as the replaceable part.

---

## What gets a photo

Be honest about this. Two of three projects have nothing to show.

- **LEGO sorting** — the only project with genuine visual material. Pieces being
  classified, the rig, a confusion matrix, before-and-after on the data pipeline fix.
  Worth a deep-dive page of its own in this phase.
- **Order platform** — nothing photogenic. The diagram is the visual.
- **Multi-Cloud** — nothing photogenic. Terraform output and denied-access test results
  are text, and belong in the prose.

Don't manufacture screenshots of terminal output to fill space. An architecture diagram
earns its place; a screenshot of `terraform apply` scrolling past does not.

---

## Stages

### Stage 3.0 — Carry-over fixes from Phase 2

Small, do them first.

- `/architecture` claims "plain HTML and CSS, no client-side framework" — no longer true
  since View Transitions added `ClientRouter`. Either drop View Transitions or fix the
  sentence. Decide, don't leave it wrong.
- `cv.pdf` has no cache-control and isn't fingerprinted, so an updated CV serves stale
  until CloudFront's default TTL expires. Add `no-cache`.
- Footer rule doesn't align with the content rule above it.
- Add `@astrojs/check` and run `astro check` in CI, so real type errors surface instead of
  editor noise.

### Stage 3.1 — Diagram foundations

- `src/components/diagrams/` with a shared `Diagram.astro` wrapper handling viewBox,
  `role="img"`, `<title>`/`<desc>`, caption, and responsive sizing
- Diagram-specific tokens if needed — box fill, stroke weight, arrow head. Add them to
  `tokens.css`, don't hardcode.
- Build one diagram end to end before building three.

Constraints: `--ink` for strokes and labels, `--rule` for secondary lines, `--accent` for
the one path that matters, `--muted` for annotations. No fills beyond `--paper`. No
shadows, no gradients, no rounded corners above 4px. Labels in IBM Plex Sans; anything
that is literally an AWS resource name or an ARN in IBM Plex Mono.

### Stage 3.2 — Deploy pipeline diagram

The one in section 1 above. Ship it on `/architecture` and stop. If it looks wrong, fix it
before building another.

### Stage 3.3 — Request path diagram

Section 2 above. Smaller, and by now the wrapper and conventions are settled.

### Stage 3.4 — Order platform diagram (deferred)

Not in this phase. Section 3 above describes it; the mobile problem below is the reason
it waits.

**The fanout doesn't stack.** SNS to three SQS queues is a parallel relationship, and
parallel reads horizontally. Rotate it to vertical and the queues look sequential — queue
two after queue one — which is the diagram asserting something false about the
architecture. That's not a styling problem.

When it comes back, split it into two diagrams rather than solving the rotation: the
linear path (API Gateway → Lambda → data layer), and separately the fanout. Each stacks
cleanly alone, and it lets the data-layer swap — the actual story on that page — be the
diagram shown twice, DynamoDB then Aurora.

### Stage 3.5 — Image support

- Extend the projects schema: optional `images` array, each with `src`, `alt`, `caption`
- Astro `<Image />`, WebP, explicit dimensions, lazy below the fold
- Render on deep-dive pages only
- Source images live in `src/assets/projects/`, not `public/`, so Astro optimises them

### Stage 3.6 — LEGO deep-dive page

The project with real visual material, and a genuinely good failure story: the first
version failed on pieces with no clean training examples, and accuracy only moved once the
data pipeline was fixed rather than the network.

Same decision-record structure as the order platform page. Needs material from Nalinka —
don't invent decisions or failures.

---

## Mobile

Diagrams are the first thing on this site that can't just reflow. A left-to-right pipeline
with eight boxes is unreadable at 375px.

Both diagrams in this phase are linear, so both get a **stacked vertical variant below
700px** — the flow runs top to bottom, arrows point down, relationships unchanged. A
second viewBox layout per diagram, roughly twenty lines of SVG each. This is the only
option where a phone user gets the real diagram rather than a degraded one.

Horizontal scroll is the fallback for anything that can't stack, but it costs real
comprehension — scrollable regions get missed, and a recruiter who doesn't realise they
can swipe sees half a picture. Nothing in this phase needs it.

Don't shrink to fit. Minimum 12px labels. A diagram that technically fits looks fine in
DevTools and is unreadable in a hand.

Test at 375px before committing each diagram, not at the end of the phase.

---

## Rules that still apply

- Facts come from `CONTENT.md` and the CV. Never invent projects, employers or metrics.
- Nothing about TAC beyond what's already public on the CV. **No architecture diagrams of
  TAC systems** — this rule matters more in this phase than any previous one.
- No client names on project pages.
- Azure and Terraform are project-level, never at the same weight as production AWS work.
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
