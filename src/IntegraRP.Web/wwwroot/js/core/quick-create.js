import { apiRequest } from './api-client.js';

const drawer = document.querySelector('#quick-create');
const backdrop = document.querySelector('[data-quick-create-backdrop]');
const form = document.querySelector('[data-quick-create-form]');
const errors = document.querySelector('[data-quick-create-errors]');
const result = document.querySelector('[data-quick-create-result]');
const submit = document.querySelector('[data-quick-create-submit]');
let returnFocus;

const definitions = {
  customer: { endpoint: '/api/customers', href: '/customers', payload: value => ({ name: value.name, document: value.reference || null, email: null, phone: null }) },
  opportunity: { endpoint: '/api/opportunities', href: '/opportunities/pipeline', payload: value => ({ title: value.name, notes: value.notes || null }) },
  activity: { endpoint: '/api/activities', href: '/activities', payload: value => ({ title: value.name, description: value.notes || null }) },
  quote: { endpoint: '/api/quotes', href: '/quotes', payload: value => ({ title: value.name, reference: value.reference || null, notes: value.notes || null }) },
  order: { endpoint: '/api/orders', href: '/orders', payload: value => ({ customerId: value.reference || null, notes: value.notes || value.name }) },
  inventory: { endpoint: '/api/commercial/inventory/entries', href: '/inventory', payload: value => ({ productId: value.reference || null, quantity: 1, reason: value.notes || value.name }) },
  task: { endpoint: '/api/tasks', href: '/tasks/my', payload: value => ({ title: value.name, description: value.notes || null }) }
};

function focusable() {
  return [...drawer.querySelectorAll('button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href]')];
}

function open(event) {
  returnFocus = event.currentTarget;
  drawer.setAttribute('aria-hidden', 'false');
  backdrop.hidden = false;
  document.body.classList.add('has-overlay');
  drawer.querySelector('select')?.focus();
}

function close() {
  drawer.setAttribute('aria-hidden', 'true');
  backdrop.hidden = true;
  document.body.classList.remove('has-overlay');
  returnFocus?.focus();
}

document.querySelectorAll('[data-quick-create-open]').forEach(button => button.addEventListener('click', open));
document.querySelectorAll('[data-quick-create-close]').forEach(button => button.addEventListener('click', close));
backdrop?.addEventListener('click', close);

drawer?.addEventListener('keydown', event => {
  if (event.key === 'Escape') close();
  if (event.key !== 'Tab') return;
  const controls = focusable();
  const first = controls[0];
  const last = controls.at(-1);
  if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
  if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
});

form?.addEventListener('submit', async event => {
  event.preventDefault();
  errors.hidden = true;
  result.hidden = true;
  if (!form.reportValidity()) return;
  const value = Object.fromEntries(new FormData(form));
  const definition = definitions[value.kind];
  submit.disabled = true;
  submit.setAttribute('aria-busy', 'true');
  try {
    const response = await apiRequest(definition.endpoint, { method: 'POST', body: JSON.stringify(definition.payload(value)) });
    const id = response?.id || response?.value?.id;
    const link = result.querySelector('[data-quick-create-link]');
    link.href = id ? `${definition.href}/${encodeURIComponent(id)}` : definition.href;
    result.hidden = false;
    form.reset();
    result.focus?.();
    window.dispatchEvent(new CustomEvent('integrarp:record-created', { detail: { kind: value.kind, id } }));
  } catch (error) {
    errors.textContent = error.message || 'Não foi possível salvar. Revise os dados e tente novamente.';
    errors.hidden = false;
    errors.focus();
  } finally {
    submit.disabled = false;
    submit.removeAttribute('aria-busy');
  }
});
