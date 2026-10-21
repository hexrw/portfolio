// Builds public/cv-<lang>.pdf from cv/cv.typ and src/data/profile.json.
import { writeFileSync } from 'node:fs';
import { NodeCompiler } from '@myriaddreamin/typst-ts-node-compiler';

const root = new URL('..', import.meta.url).pathname;
const compiler = NodeCompiler.create({ workspace: root, fontArgs: [{ fontPaths: [`${root}cv/fonts`] }] });

for (const lang of ['en', 'cs']) {
  const pdf = compiler.pdf({ mainFilePath: `${root}cv/cv.typ`, inputs: { lang } });
  writeFileSync(`${root}public/cv-${lang}.pdf`, pdf);
  console.log(`cv-${lang}.pdf  ${(pdf.length / 1024).toFixed(0)} KB`);
}
