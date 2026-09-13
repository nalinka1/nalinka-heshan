import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const decision = z.object({
	decision: z.string(),
	rejected: z.string(),
	why: z.string(),
});

const projectBody = z.object({
	whatItIs: z.string(),
	decisions: z.array(decision).min(1),
	whatBroke: z.string(),
});

const projects = defineCollection({
	loader: glob({ pattern: '**/*.md', base: './src/content/projects' }),
	schema: z.object({
		title: z.string(),
		slug: z.string(),
		summary: z.string(),
		stack: z.array(z.string()),
		status: z.literal('in progress').optional(),
		repo: z.string().url().optional(),
		order: z.number(),
		body: projectBody.optional(),
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
