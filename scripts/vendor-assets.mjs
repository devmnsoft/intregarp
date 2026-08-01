import { cp, mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';

const root = process.cwd();
const web = join(root, 'src/IntegraRP.Web/wwwroot/lib');

async function copy(source, destination) {
  await mkdir(dirname(destination), { recursive: true });
  await cp(join(root, source), destination, { recursive: true, force: true });
}

await copy('node_modules/bootstrap/dist/css/bootstrap.min.css', join(web, 'bootstrap/css/bootstrap.min.css'));
await copy('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js', join(web, 'bootstrap/js/bootstrap.bundle.min.js'));
await copy('node_modules/bootstrap/LICENSE', join(web, 'bootstrap/LICENSE'));
await copy('node_modules/bootstrap-icons/font/bootstrap-icons.css', join(web, 'bootstrap-icons/font/bootstrap-icons.css'));
await copy('node_modules/bootstrap-icons/font/fonts', join(web, 'bootstrap-icons/font/fonts'));
await copy('node_modules/bootstrap-icons/LICENSE.md', join(web, 'bootstrap-icons/LICENSE.md'));

const iconMap = {
  dashboard: 'speedometer2', 'my-day': 'sun', 'action-center': 'inbox', customers: 'people', contacts: 'person-vcard',
  opportunities: 'funnel', activities: 'activity', quotes: 'file-earmark-text', approvals: 'check2-circle', orders: 'receipt',
  products: 'box-seam', categories: 'tags', inventory: 'boxes', 'stock-entry': 'box-arrow-in-down', 'stock-exit': 'box-arrow-up',
  'stock-transfer': 'arrow-left-right', reservations: 'bookmark-check', tasks: 'check2-square', workflow: 'diagram-3', processes: 'bezier2',
  billing: 'cash-coin', notifications: 'bell', search: 'search', settings: 'gear', users: 'person-gear', sectors: 'diagram-2',
  roles: 'shield-lock', audit: 'journal-check', help: 'question-circle', create: 'plus-lg', edit: 'pencil', delete: 'trash', view: 'eye',
  download: 'download', upload: 'upload', print: 'printer', filter: 'filter', sort: 'sort-down', calendar: 'calendar3', timeline: 'clock-history',
  warning: 'exclamation-triangle', error: 'x-circle', success: 'check-circle', pending: 'hourglass-split', menu: 'list'
};
const symbols = [];
for (const [semanticName, bootstrapName] of Object.entries(iconMap)) {
  const svg = await readFile(join(root, `node_modules/bootstrap-icons/icons/${bootstrapName}.svg`), 'utf8');
  const viewBox = svg.match(/viewBox="([^"]+)"/)?.[1] ?? '0 0 16 16';
  const body = svg.replace(/^.*?<svg[^>]*>/s, '').replace(/<\/svg>\s*$/s, '').replaceAll('fill="currentColor"', '');
  symbols.push(`<symbol id="icon-${semanticName}" viewBox="${viewBox}">${body}</symbol>`);
}
const iconDirectory = join(root, 'src/IntegraRP.Web/wwwroot/icons');
await mkdir(iconDirectory, { recursive: true });
await writeFile(join(iconDirectory, 'integrarp-icons.svg'), `<svg xmlns="http://www.w3.org/2000/svg">${symbols.join('')}</svg>\n`);

const metadata = JSON.parse(await readFile(join(root, 'package.json'), 'utf8'));
await writeFile(join(web, 'VERSIONS.txt'), `bootstrap ${metadata.devDependencies.bootstrap}\nbootstrap-icons ${metadata.devDependencies['bootstrap-icons']}\n`);
