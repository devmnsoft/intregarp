
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

  async function load() {
    const data = await api("/api/billing/dashboard");
    if (!data) return;
    document.querySelector('[data-kpi="totalFaturadoMes"]').textContent = money(data.totalFaturadoMes);
    document.querySelector('[data-kpi="titulosEmAberto"]').textContent = data.titulosEmAberto;
    document.querySelector('[data-kpi="titulosVencidos"]').textContent = data.titulosVencidos;
    document.querySelector('[data-kpi="valorVencido"]').textContent = money(data.valorVencido);
  }

  load();
}());
