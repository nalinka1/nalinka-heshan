// A deep-dive page exists when its entry has a body, and is published unless that
// body is marked draft. Drafts still build under `astro dev` so the layout can be
// filled in locally, but never in a production build — so never on the live site.
export const isPublished = (body: { draft?: boolean } | undefined): boolean =>
	Boolean(body) && (!body!.draft || import.meta.env.DEV);
