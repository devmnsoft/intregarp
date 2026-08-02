import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

export const iconMap = {
  dashboard: 'speedometer2', 'my-day': 'sun', 'action-center': 'inbox', customers: 'people', contacts: 'person-vcard',
  opportunities: 'funnel', activities: 'activity', quotes: 'file-earmark-text', approvals: 'check2-circle', orders: 'receipt',
  products: 'box-seam', categories: 'tags', inventory: 'boxes', 'stock-entry': 'box-arrow-in-down', 'stock-exit': 'box-arrow-up',
  'stock-transfer': 'arrow-left-right', reservations: 'bookmark-check', tasks: 'check2-square', workflow: 'diagram-3', processes: 'bezier2',
  billing: 'cash-coin', notifications: 'bell', search: 'search', settings: 'gear', users: 'person-gear', sectors: 'diagram-2',
  roles: 'shield-lock', audit: 'journal-check', help: 'question-circle', create: 'plus-lg', edit: 'pencil', delete: 'trash', view: 'eye',
  download: 'download', upload: 'upload', print: 'printer', filter: 'filter', sort: 'sort-down', calendar: 'calendar3', timeline: 'clock-history',
  warning: 'exclamation-triangle', error: 'x-circle', success: 'check-circle', pending: 'hourglass-split', menu: 'list'
};

export async function generateIconSprite(root = process.cwd()) {
  const symbols = [];
  for (const [semanticName, bootstrapName] of Object.entries(iconMap)) {
    const source = join(root, 'node_modules/bootstrap-icons/icons', `${bootstrapName}.svg`);
    let svg;
    try {
      svg = await readFile(source, 'utf8');
    } catch (error) {
      throw new Error(`Ícone de origem ausente para '${semanticName}': ${source}`, { cause: error });
    }
    const viewBox = svg.match(/\bviewBox="([^"]+)"/)?.[1];
    const body = svg.match(/<svg\b[^>]*>([\s\S]*?)<\/svg>/)?.[1]?.trim();
    if (!viewBox || !body) throw new Error(`SVG de origem inválido para '${semanticName}': ${source}`);
    symbols.push(`  <symbol id="icon-${semanticName}" viewBox="${viewBox}">\n    ${body}\n  </symbol>`);
  }

  const destination = join(root, 'src/IntegraRP.Web/wwwroot/icons/integrarp-icons.svg');
  await mkdir(dirname(destination), { recursive: true });
  await writeFile(destination, `<svg xmlns="http://www.w3.org/2000/svg">\n${symbols.join('\n')}\n</svg>\n`);
  return destination;
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  await generateIconSprite();
}
