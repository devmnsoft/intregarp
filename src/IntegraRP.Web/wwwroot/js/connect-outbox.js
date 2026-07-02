
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

  async function loadOutbox() {
    const table = document.querySelector("#outbox-table tbody");
    if (!table) return;
    const status = document.getElementById("outbox-status")?.value || "";
    const rows = await api(`/api/connect/outbox?status=${encodeURIComponent(status)}`) || [];
    table.innerHTML = rows.length ? rows.map(row => `<tr><td>${row.tipoEvento}</td><td>${row.canal || ""}</td><td>${row.status}</td><td>${row.tentativas}/${row.maxTentativas}</td><td><button class="btn btn-sm btn-outline-warning" data-id="${row.id}">Processar</button></td></tr>`).join("") : '<tr><td colspan="5">Nenhum evento outbox encontrado.</td></tr>';
    table.querySelectorAll("button[data-id]").forEach(button => button.addEventListener("click", async function () {
      await api(`/api/connect/outbox/${button.dataset.id}/process`, { method: "POST" });
      showToast("Outbox processado/reprocessado.", "success");
      loadOutbox();
    }));
  }

  document.getElementById("outbox-refresh")?.addEventListener("click", loadOutbox);
  loadOutbox();
}());
