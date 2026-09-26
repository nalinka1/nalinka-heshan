# Phase 2 — Design and structure

Phase 1 is done: site is live on `nalinkaheshan.dev`, deployed by push to `master` via
GitHub Actions with OIDC, no stored AWS credentials.

Phase 2 makes it look like a deliberate thing rather than a default stylesheet, and
splits it into pages. Same rules as Phase 1: one stage at a time, every stage leaves the
site working and linkable, abandon at any point.

---

## Decisions (made — do not reopen)

- **Plain CSS with custom properties.** No Tailwind, no CSS framework. `src/styles/tokens.css`
  is the source of truth for every visual value, plus per-component styles.
- **No contact page.** Contact is three links. Footer on every page, plus the links rail
  on `/`.
- **Content lives in Astro Content Collections** — markdown files with Zod schemas. No
  CMS, no runtime, nothing new to host.
- **No JS framework.** Astro islands only if something genuinely needs state. Nothing
  currently does.
- **No animation library.** Astro View Transitions and CSS only.

---

## Routes

Five. Adding a sixth means removing one.

| Route | Job |
|---|---|
| `/` | Overview. Intro, availability rail, three project rows, links. |
| `/projects` | Index of all projects, links out to GitHub and to deep-dives. |
| `/projects/[slug]` | The deep-dive pages. Decisions and trade-offs, not feature lists. |
| `/experience` | Roles, compressed, one line each. Link to CV PDF. |
| `/architecture` | How this site deploys. Terraform and workflow linked. |

The existing single page becomes `/cv` — everything on one scrollable page, styled for
print. That's the URL to paste into applications when a site with tabs is more than the
situation calls for.

---

## Design direction — confirmed

`src/styles/tokens.css` holds the values. This section holds the intent behind them.

### What to move away from

The Phase 1 page was a warm cream background with serif headings. That combination is the
most common signature of an AI-generated page right now. Same for: terracotta accents,
tracked-out ALL-CAPS eyebrow labels above every heading, meta strings joined with middle
dots, and identical rounded cards with the same soft grey shadow.

The `PROJECTS` label above the projects section is one of these. Dropped — a rule and
spacing carry the same information.

### Palette

Five values. Deep teal-slate `#17505C` as accent, on links and the active nav item and
nothing else. Near-white `#FBFBF9`, not cream. True dark `#16181D`, not a tinted
near-black.

### Type

**IBM Plex Sans**, weights 400 and 600 only. **IBM Plex Mono** appears only where the
content is literally infrastructure — ARNs, bucket names, stack lines, the workflow
snippet on `/architecture`, the footer commit SHA. Mono as generic small-label styling is
a tell; mono for actual infrastructure is just correct.

Body measure 68ch, line-height 1.7. Left-aligned throughout, no centred columns.

### Layout patterns confirmed in the mockup

- **Intro is two columns.** Left: what you build, in prose. Right, behind a hairline rule:
  availability and links. Recruiters scan the right rail; hiring managers read the left.
- **Projects are rows, not cards.** Fixed-width label column on the left (name, stack in
  mono, status tag if any), prose on the right. Reads as a reference table rather than a
  marketing page. Hairline rules between rows, no boxes.
- **Deep-dive links read "Read the decisions"** — sets the expectation that the page
  contains trade-offs, not a feature list.
- **Footer carries the build SHA and date**, injected at build time, linking to the
  commit. The site's pitch is the pipeline; this is the one line that makes it visible.
- **No hero slogan.** The intro line is a sentence about the work, not a tagline.

### The one bold thing

Spend it on the project deep-dive pages, not on visual effect. Each one is structured as
a decision record:

- **What it is** — two sentences
- **Decisions** — each with the alternative that was rejected and why
- **What broke** — the failure that was actually interesting
- **Stack** and links

Almost no portfolio has this. It's the part that generates a conversation in an
interview, and it's content rather than decoration, so it costs nothing in performance.

For this site's own deep-dive, the ID-qualified OIDC subject claim and the Cloudflare
Registrar nameserver constraint are both genuinely good material.

### Not doing

Particle backgrounds, 3D heroes, scroll-jacking, cursor followers, fade-and-slide-up on
every section, hover lift on every card, gradient washes, shadows, dark mode toggle, blog,
CMS, contact form, analytics, visitor counter.

---

## Stages

### Stage 2.0 — Update the context files (do first)

`BUILD_PLAN.md` still shows Stage 1.3 and the apex CNAME as unchecked; `CLAUDE.md` stops
at Stage 1.2. Both are stale — the pipeline works and the apex resolves. Fix them before
the next build session or the agent will try to redo settled work. Commit on its own.

### Stage 2.1 — Design system, single page restyled

- `src/styles/tokens.css` in place (already written — don't regenerate it)
- `src/layouts/BaseLayout.astro` — head, skip link, nav, footer with build SHA
- Restyle the existing page against the tokens
- Focus states visible, `prefers-reduced-motion` respected

Still one page at the end of this. Ship it. Don't split routes in the same commit as
styling — if something looks wrong you want to know which change caused it.

### Stage 2.2 — Content collections and the route split

- `src/content/config.ts` with Zod schemas for `projects` and `roles`
- Move copy from `CONTENT.md` into markdown files
- Build `/`, `/projects`, `/experience`
- Existing page moves to `/cv` with a print stylesheet

No visual changes in this stage. Tokens are settled.

### Stage 2.3 — Project deep-dives

- `/projects/[slug]` from the collection
- Write one page properly before writing three. AWS Event-Driven Order Platform first.
- Projects without a deep-dive just don't link to one. Don't write thin pages to fill the
  pattern.

### Stage 2.4 — `/architecture`

Content sketch is already in `CONTENT.md`. Link the Terraform and the workflow file.
Keep it accurate to what's actually deployed — this is the page most likely to be read
closely by someone who knows the stack.

### Stage 2.5 — Polish and pipeline

- Mobile check on a real phone
- Astro View Transitions between routes
- Cache-control: long `max-age` on hashed assets, `no-cache` on HTML, set per-path during
  the S3 sync
- `aws s3 sync --delete` so removed pages actually disappear
- Invalidation scoped to HTML paths rather than `/*`
- Lighthouse — 100 on performance is free with static Astro; anything less means
  something got added that shouldn't have been

---

## Content rules (unchanged from Phase 1)

- Facts come from `CONTENT.md` and the CV. Never invent projects, employers or metrics.
- Nothing about TAC beyond what's already public on the CV.
- Azure and Terraform are project-level. Never presented at the same weight as production
  AWS work. The "In progress" tag on the secure-documents row carries this.
- React stays off unless decided otherwise.
- Don't use unconfirmed skills: JUnit, Mockito, Jest, Cypress, SonarQube, Redis, Kinesis,
  Ionic, Graylog.

## Tone (unchanged)

Plain, specific, first person, short sentences. Banned: leverage, spearheaded,
seamlessly, robust, cutting-edge, passionate, dynamic, results-driven, "not just X but
Y", "with a focus on". No hero slogan.

---

## Failure modes for this phase

- Restyling `/` four times instead of shipping 2.2
- Writing three thin deep-dive pages instead of one good one
- Adding a sixth route
- Adding a sixth colour
- Reaching for Tailwind halfway through because a component felt fiddly
- Letting `/architecture` drift from what's actually deployed