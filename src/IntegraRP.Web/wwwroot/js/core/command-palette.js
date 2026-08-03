"use strict";
(() => {
  const palette = document.querySelector('[data-command-palette]');
  const input = document.querySelector('[data-command-input]');
  const results = document.querySelector('[data-command-results]');
  const status = document.querySelector('[data-command-status]');
  const sources = [
    ['Clientes', '/api/customers', '/customers/', ['name', 'nome', 'document']],
    ['Oportunidades', '/api/opportunities', '/opportunities/', ['title', 'name', 'nome']],
    ['Orçamentos', '/api/quotes', '/quotes/', ['number', 'title', 'name']],
    ['Pedidos', '/api/orders', '/orders/', ['number', 'code', 'id']],
    ['Produtos', '/api/products', '/products/', ['name', 'nome', 'sku']],
    ['Tarefas', '/api/tasks', '/tasks/', ['title', 'name', 'nome']],
    ['Processos', '/api/processos/templates', '/flow/instances/', ['name', 'nome', 'title']],
    ['Usuários', '/api/usuarios', '/admin/users/', ['name', 'nome', 'email']],
    ['Faturamento', '/api/billing/pending', '/orders/billing/', ['number', 'customerName', 'id']]
  ];
  let timer;
  let controller;
  let active = -1;
  let returnFocus;

  function close() { if (!palette || palette.hidden) return; controller?.abort(); palette.hidden = true; returnFocus?.focus(); }
  function open(event) { if (!palette) return; returnFocus = event?.currentTarget || document.activeElement; palette.hidden = false; window.setTimeout(() => input?.focus(), 0); }
  function label(record, fields) { return fields.map(field => record?.[field]).find(Boolean)?.toString() || 'Registro sem título'; }
  function items(payload) { return Array.isArray(payload) ? payload : payload?.items || payload?.data || []; }
  function render(found) {
    active = -1;
    const nodes = found.map((entry, index) => {
      const link = document.createElement('a');
      link.href = `${entry.href}${encodeURIComponent(entry.id || '')}`;
      link.setAttribute('role', 'option');
      link.dataset.commandOption = String(index);
      const group = document.createElement('small'); group.textContent = entry.group;
      const title = document.createElement('strong'); title.textContent = entry.title;
      link.append(group, title);
      return link;
    });
    results.replaceChildren(...nodes);
    status.textContent = found.length ? `${found.length} resultado(s) encontrado(s).` : 'Nenhum resultado. Tente outro nome, documento ou código.';
  }
  async function search(term) {
    controller?.abort(); controller = new AbortController();
    status.textContent = 'Pesquisando em todos os módulos...'; results.replaceChildren();
    const settled = await Promise.allSettled(sources.map(async ([group, path, href, fields]) => {
      const response = await fetch(`/api/proxy?path=${encodeURIComponent(`${path}?q=${encodeURIComponent(term)}`)}`, { signal: controller.signal, credentials: 'same-origin' });
      if (!response.ok) throw new Error(group);
      const records = items(await response.json());
      return records.filter(record => label(record, fields).toLocaleLowerCase('pt-BR').includes(term.toLocaleLowerCase('pt-BR'))).slice(0, 4).map(record => ({ group, href, id: record.id, title: label(record, fields) }));
    }));
    if (controller.signal.aborted) return;
    render(settled.filter(value => value.status === 'fulfilled').flatMap(value => value.value).slice(0, 24));
  }
  input?.addEventListener('input', () => { clearTimeout(timer); const term = input.value.trim(); if (term.length < 2) { results.replaceChildren(); status.textContent = 'Digite pelo menos 2 caracteres.'; return; } timer = window.setTimeout(() => search(term), 280); });
  input?.addEventListener('keydown', event => {
    const options = [...results.querySelectorAll('[data-command-option]')]; if (!options.length) return;
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp') { event.preventDefault(); active = (active + (event.key === 'ArrowDown' ? 1 : -1) + options.length) % options.length; options.forEach((option, index) => option.setAttribute('aria-selected', String(index === active))); options[active].scrollIntoView({ block: 'nearest' }); }
    if (event.key === 'Enter' && active >= 0) { event.preventDefault(); options[active].click(); }
  });
  document.querySelectorAll('[data-command-open]').forEach(element => element.addEventListener('click', open));
  document.querySelectorAll('[data-command-close]').forEach(element => element.addEventListener('click', close));
  document.addEventListener('keydown', event => { if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') { event.preventDefault(); open(event); } if (event.key === 'Escape') close(); });
  palette?.addEventListener('click', event => { if (event.target === palette) close(); });
})();
