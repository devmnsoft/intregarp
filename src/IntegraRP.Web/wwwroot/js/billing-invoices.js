
(function () {
  "use strict";

  const tenantId = "00000000-0000-0000-0000-000000000001";

  async function api(path, options) {
    const response = await fetch(path, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        "x-tenant-id": tenantId,
        ...(options && options.headers ? options.headers : {})
      }
    });

    if (response.status === 401 || response.status === 403) {
      showToast("Sessão sem permissão para esta ação.", "danger");
      return null;
    }

    if (!response.ok) {
      showToast("Não foi possível concluir. Verifique os dados e tente novamente.", "danger");
      return null;
    }

    return response.json();
  }

  function showToast(message, type) {
    const toast = document.createElement("div");
    toast.className = `alert alert-${type || "info"} position-fixed bottom-0 end-0 m-3`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(function () { toast.remove(); }, 3500);
  }

  function money(value) {
    return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value || 0);
  }

  async function loadInvoices() {
    const table = document.querySelector("#invoices-table tbody");
    if (!table) return;
    table.innerHTML = '<tr><td colspan="5">Carregando...</td></tr>';
    const status = document.getElementById("invoice-filter")?.value || "";
    const rows = await api(`/api/billing/invoices?status=${encodeURIComponent(status)}`) || [];
    table.innerHTML = rows.length ? rows.map(row => `<tr><td>${row.codigo}</td><td>${row.status}</td><td>${row.clienteId}</td><td>${money(row.valorTotal)}</td><td><a class="btn btn-sm btn-outline-primary" href="/billing/invoices/${row.id}">Abrir</a></td></tr>`).join("") : '<tr><td colspan="5">Nenhuma fatura encontrada.</td></tr>';
  }

  document.getElementById("invoice-refresh")?.addEventListener("click", loadInvoices);
  document.getElementById("invoice-form")?.addEventListener("submit", async function (event) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const payload = { clienteId: form.get("clienteId"), codigo: form.get("codigo") || null, pedidoId: null, dataVencimento: null, observacao: null };
    const created = await api("/api/billing/invoices", { method: "POST", body: JSON.stringify(payload) });
    if (created) { showToast("Fatura criada com sucesso.", "success"); window.location.href = `/billing/invoices/${created.invoice.id}`; }
  });

  loadInvoices();
}());
