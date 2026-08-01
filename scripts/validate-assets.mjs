import { readFile, readdir } from 'node:fs/promises';
import { join } from 'node:path';

const root = join(process.cwd(), 'src/IntegraRP.Web/wwwroot');
async function walk(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  return (await Promise.all(entries.map(entry => entry.isDirectory() ? walk(join(directory, entry.name)) : join(directory, entry.name)))).flat();
}
const svgFiles = (await walk(root)).filter(file => file.endsWith('.svg'));
for (const file of svgFiles) {
  const source = await readFile(file, 'utf8');
  if (/<script\b|javascript:|<image[^>]+href=["']https?:|data:image\//i.test(source)) throw new Error(`SVG inseguro ou externo: ${file}`);
}
const sprite = await readFile(join(root, 'icons/integrarp-icons.svg'), 'utf8');
const views = (await walk(join(process.cwd(), 'src/IntegraRP.Web/Views'))).filter(file => file.endsWith('.cshtml'));
for (const view of views) {
  const source = await readFile(view, 'utf8');
  for (const match of source.matchAll(/<app-icon\s+[^>]*name="([^"]+)"/g)) {
    if (match[1].startsWith('@')) continue;
    if (!sprite.includes(`id="icon-${match[1]}"`)) throw new Error(`Ícone desconhecido '${match[1]}' em ${view}`);
  }
}
console.log(`${svgFiles.length} SVGs e ${views.length} views validados.`);
