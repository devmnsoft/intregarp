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

const metadata = JSON.parse(await readFile(join(root, 'package.json'), 'utf8'));
await writeFile(join(web, 'VERSIONS.txt'), `bootstrap ${metadata.devDependencies.bootstrap}\nbootstrap-icons ${metadata.devDependencies['bootstrap-icons']}\n`);
