import { cp, mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { generateIconSprite } from './generate-icon-sprite.mjs';

const root = process.cwd();
const web = join(root, 'src/IntegraRP.Web/wwwroot/lib');

async function copy(source, destination) {
  await mkdir(dirname(destination), { recursive: true });
  await cp(join(root, source), destination, { recursive: true, force: true });
}

await copy('node_modules/bootstrap/dist/css/bootstrap.min.css', join(web, 'bootstrap/css/bootstrap.min.css'));
await copy('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js', join(web, 'bootstrap/js/bootstrap.bundle.min.js'));
await copy('node_modules/bootstrap/LICENSE', join(web, 'bootstrap/LICENSE'));
await generateIconSprite(root);

const metadata = JSON.parse(await readFile(join(root, 'package.json'), 'utf8'));
await writeFile(join(web, 'VERSIONS.txt'), `bootstrap ${metadata.devDependencies.bootstrap}\nbootstrap-icons ${metadata.devDependencies['bootstrap-icons']}\n`);
