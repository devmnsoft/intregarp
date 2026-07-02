
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

  async function loadTemplates() {
    const host = document.getElementById("templates-list");
    if (!host) return;
    const rows = await api("/api/connect/templates") || [];
    host.innerHTML = rows.length ? rows.map(row => `<div class="col-md-4"><div class="card p-3"><strong>${row.codigo}</strong><span>${row.canal}</span><p>${row.nome}</p></div></div>`).join("") : '<p>Nenhum template cadastrado.</p>';
  }

  document.getElementById("template-form")?.addEventListener("submit", async function (event) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const payload = Object.fromEntries(form.entries());
    payload.publico = true;
    payload.assuntoTemplate = null;
    const created = await api("/api/connect/templates", { method: "POST", body: JSON.stringify(payload) });
    if (created) { showToast("Template criado.", "success"); window.location.href = "/connect/templates"; }
  });

  loadTemplates();
}());
