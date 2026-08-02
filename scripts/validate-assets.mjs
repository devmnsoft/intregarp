import { execFileSync } from 'node:child_process';
import { readFile, readdir } from 'node:fs/promises';
import { extname, join, relative } from 'node:path';

const repository = process.cwd();
const webRoot = join(repository, 'src/IntegraRP.Web/wwwroot');
const forbiddenExtensions = new Set(['.woff', '.woff2', '.ttf', '.eot', '.otf', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.zip', '.pdf']);

async function walk(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  return (await Promise.all(entries.map(entry => entry.isDirectory() ? walk(join(directory, entry.name)) : join(directory, entry.name)))).flat();
}

function gitPaths(arguments_) {
  try {
    return execFileSync('git', arguments_, { cwd: repository, encoding: 'utf8' }).split(/\r?\n/).filter(Boolean);
  } catch {
    return [];
  }
}

const changed = new Set([
  ...gitPaths(['diff', '--name-only', '--diff-filter=ACM', 'HEAD']),
  ...gitPaths(['diff', '--cached', '--name-only', '--diff-filter=ACM']),
  ...gitPaths(['ls-files', '--others', '--exclude-standard'])
]);
if (gitPaths(['rev-parse', '--verify', 'HEAD^']).length) {
  for (const path of gitPaths(['diff', '--name-only', '--diff-filter=ACM', 'HEAD^', 'HEAD'])) changed.add(path);
}
const forbidden = [...changed].filter(path => forbiddenExtensions.has(extname(path).toLowerCase()));
if (forbidden.length) throw new Error(`Arquivos binários adicionados ou alterados:\n${forbidden.join('\n')}`);

const files = await walk(webRoot);
const svgFiles = files.filter(file => extname(file).toLowerCase() === '.svg');
const spritePath = join(webRoot, 'icons/integrarp-icons.svg');
for (const file of svgFiles) {
  const source = await readFile(file, 'utf8');
  const isSprite = file === spritePath;
  if (!isSprite && !/<svg\b[^>]*\bviewBox=/i.test(source)) throw new Error(`SVG sem viewBox: ${relative(repository, file)}`);
  if (isSprite && /<symbol\b(?![^>]*\bviewBox=)/i.test(source)) throw new Error('Símbolo sem viewBox no sprite.');
  if (/<script\b|javascript:|data:image\/|(?:href|src)=["']https?:\/\//i.test(source)) {
    throw new Error(`SVG contém script, URL externa ou Base64: ${relative(repository, file)}`);
  }
}

const sprite = await readFile(spritePath, 'utf8');
const ids = [...sprite.matchAll(/\bid="([^"]+)"/g)].map(match => match[1]);
const duplicateIds = ids.filter((id, index) => ids.indexOf(id) !== index);
if (duplicateIds.length) throw new Error(`IDs duplicados no sprite: ${[...new Set(duplicateIds)].join(', ')}`);

const sourceFiles = (await walk(join(repository, 'src/IntegraRP.Web')))
  .filter(file => ['.cs', '.cshtml', '.css', '.js'].includes(extname(file)) && !file.includes('/wwwroot/lib/'));
for (const file of sourceFiles) {
  const source = await readFile(file, 'utf8');
  if (/bootstrap-icons(?:\.css|\.woff2?|\/font)|class=["'][^"']*\bbi\s+bi-/i.test(source)) {
    throw new Error(`Referência à fonte Bootstrap Icons: ${relative(repository, file)}`);
  }
  if (/[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}]/u.test(source)) {
    throw new Error(`Caractere Unicode usado como possível ícone: ${relative(repository, file)}`);
  }
  for (const match of source.matchAll(/<app-icon\s+[^>]*name="([^"]+)"/g)) {
    if (!match[1].startsWith('@') && !ids.includes(`icon-${match[1]}`)) {
      throw new Error(`Ícone desconhecido '${match[1]}' em ${relative(repository, file)}`);
    }
  }
}

console.log(`${svgFiles.length} SVGs, ${ids.length} símbolos e ${changed.size} alterações validados.`);
