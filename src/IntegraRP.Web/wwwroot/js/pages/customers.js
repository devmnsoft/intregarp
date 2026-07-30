const status = document.querySelector('#customers-status');
const list = document.querySelector('#customers-list');
const empty = document.querySelector('#customers-empty');
const form = document.querySelector('#customer-form');

async function api(path, options = {}) {
  const response = await fetch(`/api/proxy?path=${encodeURIComponent(path)}`, {
    ...options,
    headers: { 'Content-Type': 'application/json', 'X-Correlation-Id': crypto.randomUUID(), ...(options.headers || {}) }
  });
  if (!response.ok) {
    const problem = await response.json().catch(() => ({}));
    throw new Error(problem.detail || 'Não foi possível concluir a operação.');
  }
  return response.status === 204 ? null : response.json();
}

function text(value) { const node = document.createTextNode(value ?? ''); const span = document.createElement('span'); span.append(node); return span.innerHTML; }
async function load() {
  status.className = 'alert alert-info'; status.textContent = 'Carregando clientes...';
  try {
    const data = await api('/api/customers'); const customers = data.items || data || [];
    list.innerHTML = customers.map(x => `<tr><td>${text(x.name || x.nome)}</td><td>${text(x.document || x.documento)}</td><td>${text(x.email)}</td><td><span class="badge text-bg-${(x.status === 'ativo' || x.active) ? 'success' : 'secondary'}">${text(x.status || 'ativo')}</span></td></tr>`).join('');
    empty.classList.toggle('d-none', customers.length !== 0); status.classList.add('d-none');
  } catch (error) { status.className = 'alert alert-danger'; status.textContent = error.message; }
}
form?.addEventListener('submit', async event => {
  event.preventDefault(); form.setAttribute('aria-busy', 'true'); status.className = 'alert alert-info'; status.textContent = 'Salvando cliente...';
  try {
    const values = Object.fromEntries(new FormData(form));
    await api('/api/customers', { method: 'POST', body: JSON.stringify({ name: values.name, document: values.document || null, email: values.email || null, phone: null }) });
    form.reset(); await load(); status.className = 'alert alert-success'; status.classList.remove('d-none'); status.textContent = 'Cliente salvo com sucesso.';
  } catch (error) { status.className = 'alert alert-danger'; status.textContent = error.message; }
  finally { form.setAttribute('aria-busy', 'false'); }
});
load();
