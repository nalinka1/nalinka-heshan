import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const decision = z.object({
	decision: z.string(),
	rejected: z.string(),
	why: z.string(),
});

// Deep-dive page content. Only whatItIs is required; each other section renders
// only when present, so a hands-on project and a decision-record project share
// one template. `draft: true` builds the page in `astro dev` only — see
// src/lib/published.ts.
const projectBody = z.object({
	draft: z.boolean().optional(),
	whatItIs: z.string(),
	built: z.array(z.string()).min(1).optional(),
	decisions: z.array(decision).min(1).optional(),
	whatBroke: z.string().optional(),
});

const projects = defineCollection({
	loader: glob({ pattern: '**/*.md', base: './src/content/projects' }),
	schema: ({ image }) => z.object({
		title: z.string(),
		slug: z.string(),
		summary: z.string(),
		stack: z.array(z.string()),
		status: z.literal('in progress').optional(),
		repo: z.string().url().optional(),
		order: z.number(),
		body: projectBody.optional(),
		// Deep-dive pages only, never the project rows. `src` is relative to the
		// markdown file and points into src/assets/projects/ so Astro optimises it.
		images: z
			.array(
				z.object({
					src: image(),
					alt: z.string().min(1),
					caption: z.string().optional(),
				}),
			)
			.optional(),
	}),
});

const roles = defineCollection({
	loader: glob({ pattern: '**/*.md', base: './src/content/roles' }),
	schema: z.object({
		company: z.string(),
		title: z.string(),
		location: z.string(),
		startDate: z.string(),
		endDate: z.string().optional(),
		summary: z.string(),
		order: z.number(),
	}),
});

export const collections = { projects, roles };
