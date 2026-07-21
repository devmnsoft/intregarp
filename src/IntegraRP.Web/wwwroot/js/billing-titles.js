
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

  async function loadTitles() {
    const table = document.querySelector("#titles-table tbody");
    if (!table) return;
    table.innerHTML = '<tr><td colspan="5">Carregando...</td></tr>';
    const rows = await api("/api/billing/titles") || [];
    table.innerHTML = rows.length ? rows.map(row => `<tr><td>${row.codigo}</td><td>${row.status}</td><td>${row.dataVencimento}</td><td>${money(row.valorAberto)}</td><td><a class="btn btn-sm btn-outline-primary" href="/billing/titles/${row.id}">Abrir</a></td></tr>`).join("") : '<tr><td colspan="5">Nenhum título encontrado.</td></tr>';
  }

  document.querySelector('[data-action="boleto"]')?.addEventListener("click", async function () {
    
    const id = document.querySelector(".integrarp-page").dataset.id;
    const boleto = await api(`/api/billing/titles/${id}/generate-boleto`, { method: "POST", body: JSON.stringify({ observacao: "Gerado pela tela" }) });
    if (boleto) showToast(`Boleto fake gerado: ${boleto.linhaDigitavel}`, "success");
  });

  loadTitles();
}());
