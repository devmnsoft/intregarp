import { apiRequest } from '../core/api-client.js';

const status = document.querySelector('#customers-status');
const list = document.querySelector('#customers-list');
const empty = document.querySelector('#customers-empty');
const form = document.querySelector('#customer-form');

function cell(value) {
  const element = document.createElement('td');
  element.textContent = value ?? '';
  return element;
}

function renderCustomer(customer) {
  const row = document.createElement('tr');
  row.append(cell(customer.name || customer.nome));
  row.append(cell(customer.document || customer.documento));
  row.append(cell(customer.email));
  const statusCell = document.createElement('td');
  const badge = document.createElement('span');
  const isActive = customer.status === 'ativo' || customer.active;
  badge.className = `badge text-bg-${isActive ? 'success' : 'secondary'}`;
  badge.textContent = customer.status || (isActive ? 'ativo' : 'inativo');
  statusCell.append(badge);
  row.append(statusCell);
  return row;
}

async function load() {
  status.className = 'alert alert-info';
  status.textContent = 'Carregando clientes...';
  try {
    const data = await apiRequest('/api/customers');
    const customers = data.items || data || [];
    list.replaceChildren(...customers.map(renderCustomer));
    empty.classList.toggle('d-none', customers.length !== 0);
    status.classList.add('d-none');
  } catch (error) {
    status.className = 'alert alert-danger';
    status.textContent = error.message;
  }
}

form?.addEventListener('submit', async event => {
  event.preventDefault();
  form.setAttribute('aria-busy', 'true');
  status.className = 'alert alert-info';
  status.textContent = 'Salvando cliente...';
  try {
    const values = Object.fromEntries(new FormData(form));
    await apiRequest('/api/customers', {
      method: 'POST',
      body: JSON.stringify({ name: values.name, document: values.document || null, email: values.email || null, phone: null })
    });
    form.reset();
    await load();
    status.className = 'alert alert-success';
    status.classList.remove('d-none');
    status.textContent = 'Cliente salvo com sucesso.';
  } catch (error) {
    status.className = 'alert alert-danger';
    status.textContent = error.message;
  } finally {
    form.setAttribute('aria-busy', 'false');
  }
});

load();
