import { z } from 'astro/zod';
import raw from './profile.json';

export type Lang = 'en' | 'cs';
export const langs: Lang[] = ['en', 'cs'];

// Strict objects everywhere: a field the schema doesn't know (school, phone, address...) fails the build,
// so private CV details can't slip into this public repo.
const L = z.strictObject({ en: z.string().min(1), cs: z.string().min(1) });
const LorS = z.union([z.string().min(1), L]);
const month = z.string().regex(/^\d{4}-\d{2}$/);

const schema = z.strictObject({
  basics: z.strictObject({
    name: z.string(),
    handle: z.string(),
    title: L,
    location: L,
    timezone: z.string(),
    email: z.email(),
    website: z.url(),
    photo: z.string(),
    lead: L,
    summary: L,
    about: L,
    links: z.array(z.strictObject({ label: z.string(), url: z.url() })),
  }),
  experience: z.array(z.strictObject({ company: LorS, role: L, what: L, summary: L, start: month, end: month.nullable() })),
  ventures: z.array(z.strictObject({ name: z.string(), url: z.url(), kind: L, summary: L, image: z.string() })),
  projects: z.array(z.strictObject({ name: z.string(), url: z.url(), summary: L, stack: z.array(z.string()), year: z.number().int(), image: z.string().optional() })),
  writing: z.array(z.strictObject({ title: z.string(), url: z.url(), date: month, image: z.string().optional() })),
  skills: z.array(z.strictObject({ group: L, items: z.array(z.string()) })),
  languages: z.array(z.strictObject({ name: L, level: L })),
});

export const profile = schema.parse(raw);

export const t = (v: string | { en: string; cs: string }, lang: Lang) => (typeof v === 'string' ? v : v[lang]);

const ym = (s: string) => new Date(`${s}-01T00:00:00Z`);

export function range(start: string, end: string | null, lang: Lang) {
  // Czech CLDR has no short month names, so cs gets 10/2025 instead of "říjen 2025".
  const f = new Intl.DateTimeFormat(lang, { month: lang === 'cs' ? 'numeric' : 'short', year: 'numeric', timeZone: 'UTC' });
  return end ? f.formatRange(ym(start), ym(end)) : `${f.format(ym(start))} – ${lang === 'cs' ? 'dosud' : 'now'}`;
}

export const year = (s: string) => s.slice(0, 4);
