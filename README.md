# hexrw.com

Portfolio and CV of Petr Kolonicz, in English (`/`) and Czech (`/cs/`).

## Editing content

All content lives in `src/data/profile.json`. Every human-readable string has an `en` and a `cs` value. UI labels are in `src/data/ui.ts`.

The schema in `src/data/profile.ts` is strict: an unknown field (for example `phone` or `school`) fails the build. This repo is public, so private details must never be added here.

## Commands

| Command | What it does |
| --- | --- |
| `pnpm dev` | Local dev server |
| `pnpm cv` | Builds `public/cv-en.pdf` and `public/cv-cs.pdf` from `cv/cv.typ` (Typst) |
| `pnpm build` | CV PDFs plus the static site in `dist/` |
| `pnpm deploy` | Build and deploy to Cloudflare Workers |

## Deploy

Every push to `main` builds and deploys through `.github/workflows/deploy.yml`. It needs a `CLOUDFLARE_API_TOKEN` repository secret with **Workers Scripts: Edit** on the webspen account and **Workers Routes: Edit** on the hexrw.com zone.
