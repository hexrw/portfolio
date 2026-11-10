# hexrw.com

Portfolio and CV of Petr Kolonicz, in English (`/`) and Czech (`/cs/`).

## Editing content

All content lives in `src/data/profile.json`. Every human-readable string has an `en` and a `cs` value. UI labels are in `src/data/ui.ts`.

The schema in `src/data/profile.ts` is strict: an unknown field (for example `phone` or `school`) fails the build. This repo is public, so private details must never be added here.

## Commands

| Command | What it does |
| --- | --- |
| `bun dev` | Local dev server |
| `bun run cv` | Builds `public/cv-en.pdf` and `public/cv-cs.pdf` from `cv/cv.typ` (Typst) |
| `bun run build` | CV PDFs plus the static site in `dist/` |
| `bun run deploy` | Build and deploy to Cloudflare Workers |

## Deploy

Cloudflare Workers Builds deploys every push to `main` (Worker `hexrw-portfolio`, build command `bun run build`, deploy command `npx wrangler deploy`). `bun run deploy` deploys from a local machine.
