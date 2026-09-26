// Shared layout maths for the linear diagrams (deploy pipeline, request path).
// Box widths come from an estimated text width per label, so changing a label
// reflows the boxes — no measuring text at build time, no client JS.

export interface Part {
	text: string;
	mono?: boolean;
}

export type Lines = Part[][];

// Rough glyph widths at 12px IBM Plex Sans/Mono — good enough to size boxes
// that fit their labels.
const CHAR_W = 6.3;
const MONO_CHAR_W = 6.8;

export const lineWidth = (parts: Part[], fontSize = 12) =>
	parts.reduce((sum, p) => sum + p.text.length * (p.mono ? MONO_CHAR_W : CHAR_W), 0) * (fontSize / 12);

// Smallest label a reader may ever see, in CSS px (PHASE_3_PLAN.md).
export const MIN_LABEL_PX = 12;

// --- Desktop: one row, left to right -------------------------------------
// The viewBox is as wide as the content column at --page-max (60rem minus
// 2 × --space-6 padding), so at full width one user unit is one CSS pixel
// and the row fills the column edge to edge.
export const D_WIDTH = 912;
export const D_FONT = 14;
export const D_PAD_X = 14;
export const D_PAD_Y = 14;
export const D_MIN_W = 84;
export const D_GAP = 28;
export const D_EDGE = 1; // half the stroke width, so the outer box edges don't clip
export const D_LINE_H = 18;

export interface Box<T> {
	node: T;
	x: number;
	y: number;
	w: number;
	h: number;
}

/** Lays nodes out in one row across D_WIDTH. Leftover width goes evenly to
 * every box, so the row spans the full column. Throws if the labels don't fit. */
export function layoutRow<T>(name: string, nodes: T[], lines: (n: T) => Lines): Box<T>[] {
	const h = Math.max(...nodes.map((n) => lines(n).length)) * D_LINE_H + D_PAD_Y * 2;
	const natural = nodes.map((n) =>
		Math.max(D_MIN_W, Math.max(...lines(n).map((l) => lineWidth(l, D_FONT))) + D_PAD_X * 2),
	);
	const spare = D_WIDTH - D_EDGE * 2 - D_GAP * (nodes.length - 1) - natural.reduce((a, b) => a + b, 0);
	if (spare < 0) {
		throw new Error(`${name}: desktop labels overflow the row by ${Math.ceil(-spare)} units`);
	}

	let cursorX = D_EDGE;
	return nodes.map((node, i) => {
		const w = natural[i] + spare / nodes.length;
		const box = { node, x: cursorX, y: D_EDGE, w, h };
		cursorX += w + D_GAP;
		return box;
	});
}

// Below this viewport width a D_WIDTH row would scale labels under
// MIN_LABEL_PX, so the stacked layout takes over. 48 = the page's side
// padding (2 × --space-6).
export const STACK_BELOW = Math.ceil((D_WIDTH * MIN_LABEL_PX) / D_FONT) + 48;

// --- Mobile: stacked top to bottom, arrows pointing down -----------------
export const M_WIDTH = 300;
export const M_BOX_H = 44;
export const M_BOX_W = M_WIDTH - 48;
export const M_GAP = 34;
export const M_MARGIN = 24;
export const M_LINE_H = 15;

/** Stacks nodes top to bottom, centred in M_WIDTH. Returns the boxes and the
 * y just past the last gap, for placing anything below the stack. */
export function layoutStack<T>(nodes: T[], lines: (n: T) => Lines): { boxes: Box<T>[]; bottom: number } {
	let cursorY = M_MARGIN;
	const boxes = nodes.map((node) => {
		const h = M_BOX_H + (lines(node).length - 1) * M_LINE_H;
		const box = { node, x: (M_WIDTH - M_BOX_W) / 2, y: cursorY, w: M_BOX_W, h };
		cursorY += h + M_GAP;
		return box;
	});
	return { boxes, bottom: cursorY };
}

/** y for a <text> whose tspans step down by lineH, so the block is centred in the box. */
export const textY = (box: { y: number; h: number }, lineCount: number, lineH: number) =>
	box.y + box.h / 2 - ((lineCount - 1) * lineH) / 2;
