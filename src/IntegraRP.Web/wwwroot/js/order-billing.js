
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

  const page = document.querySelector(".integrarp-page[data-order-id]");
  let invoiceId = null;
  let titleId = null;

  page?.querySelector('[data-action="generate-invoice"]')?.addEventListener("click", async function () {
    const orderId = page.dataset.orderId;
    const invoice = await api(`/api/billing/invoices/from-order/${orderId}`, { method: "POST", body: JSON.stringify({ clienteId: "00000000-0000-0000-0000-000000000101", codigo: null, dataVencimento: null }) });
    if (invoice) { invoiceId = invoice.invoice.id; document.getElementById("order-billing-status").textContent = `Fatura ${invoice.invoice.codigo} gerada.`; showToast("Fatura gerada a partir do pedido.", "success"); }
  });

  page?.querySelector('[data-action="generate-title"]')?.addEventListener("click", async function () {
    if (!invoiceId) { showToast("Gere a fatura primeiro.", "warning"); return; }
    const title = await api(`/api/billing/titles/from-invoice/${invoiceId}`, { method: "POST", body: JSON.stringify({ dataVencimento: null, formaPagamento: "boleto_fake" }) });
    if (title) { titleId = title.id; showToast("Título financeiro criado.", "success"); }
  });

  page?.querySelector('[data-action="generate-boleto"]')?.addEventListener("click", async function () {
    if (!titleId) { showToast("Gere o título primeiro.", "warning"); return; }
    const boleto = await api(`/api/billing/titles/${titleId}/generate-boleto`, { method: "POST", body: JSON.stringify({ observacao: "MVP demo" }) });
    if (boleto) showToast(`Boleto fake/log: ${boleto.linhaDigitavel}`, "success");
  });

  page?.querySelector('[data-action="send-message"]')?.addEventListener("click", async function () {
    const outbox = await api("/api/connect/outbox", { method: "POST", body: JSON.stringify({ tipoEvento: "flow.notificacao.enfileirada", canal: "email", origemTipo: "pedido", origemId: page.dataset.orderId, prioridade: "normal", payload: { demo: true } }) });
    if (outbox) showToast("Mensagem fake/log enfileirada no outbox.", "success");
  });
}());
