(() => {
  "use strict";
  const state = { tenants: [], trigger: null };
  const one = selector => document.querySelector(selector);
  const all = selector => [...document.querySelectorAll(selector)];
  const setVisible = (selector, visible) => { const element = one(selector); if (element) element.hidden = !visible; };
  const count = value => Array.isArray(value) ? value.length : Array.isArray(value?.items) ? value.items.length : 0;
  const items = value => Array.isArray(value) ? value : value?.items ?? [];
  const escapeHtml = value => String(value ?? "").replace(/[&<>"']/g, character => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[character]);

  function render(filter = "") {
    const normalized = filter.trim().toLocaleLowerCase("pt-BR");
    const rows = state.tenants.filter(tenant => `${tenant.nome ?? ""} ${tenant.slug ?? ""}`.toLocaleLowerCase("pt-BR").includes(normalized));
    one("[data-superadmin-rows]").innerHTML = rows.map(tenant => `<tr><td><strong>${escapeHtml(tenant.nome ?? tenant.name)}</strong><br><small>${escapeHtml(tenant.slug)}</small></td><td><span class="app-status-badge app-status-badge--secure">${escapeHtml(tenant.status ?? "ativo")}</span></td><td>${escapeHtml(tenant.plano ?? tenant.plan ?? "—")}</td><td class="text-end"><a class="app-icon-button" href="/tenants/${encodeURIComponent(tenant.id)}" aria-label="Ver tenant ${escapeHtml(tenant.nome ?? tenant.name)}"><svg class="app-icon"><use href="/icons/integrarp-icons.svg#icon-view"></use></svg></a></td></tr>`).join("");
    setVisible("[data-superadmin-empty]", rows.length === 0);
  }

  async function load() {
    setVisible("[data-superadmin-loading]", true); setVisible("[data-superadmin-error]", false); setVisible("[data-superadmin-content]", false);
    try {
      const [tenantResponse, userResponse] = await Promise.all([fetch("/api/superadmin/tenants"), fetch("/api/superadmin/usuarios")]);
      if (!tenantResponse.ok || !userResponse.ok) throw new Error("superadmin_unavailable");
      const [tenantData, userData] = await Promise.all([tenantResponse.json(), userResponse.json()]);
      state.tenants = items(tenantData); one('[data-metric="tenants"]').textContent = count(tenantData); one('[data-metric="users"]').textContent = count(userData);
      one("[data-support-tenants]").innerHTML = state.tenants.map(tenant => `<option value="${escapeHtml(tenant.id)}">${escapeHtml(tenant.nome ?? tenant.name)}</option>`).join("");
      render(); setVisible("[data-superadmin-content]", true);
    } catch { setVisible("[data-superadmin-error]", true); }
    finally { setVisible("[data-superadmin-loading]", false); }
  }

  function closeDrawer() { const drawer = one(".app-drawer"); drawer.setAttribute("aria-hidden", "true"); setVisible("[data-app-drawer-backdrop]", false); state.trigger?.focus(); }
  all("[data-app-drawer-open]").forEach(button => button.addEventListener("click", () => { state.trigger = button; const drawer = one(`#${button.dataset.appDrawerOpen}`); drawer.setAttribute("aria-hidden", "false"); setVisible("[data-app-drawer-backdrop]", true); drawer.querySelector("select,button,input,textarea")?.focus(); }));
  all("[data-app-drawer-close],[data-app-drawer-backdrop]").forEach(button => button.addEventListener("click", closeDrawer));
  document.addEventListener("keydown", event => { if (event.key === "Escape" && one('.app-drawer[aria-hidden="false"]')) closeDrawer(); });
  one("[data-superadmin-filter]")?.addEventListener("input", event => render(event.target.value)); one("[data-superadmin-retry]")?.addEventListener("click", load);
  one("[data-support-context-form]")?.addEventListener("submit", event => { event.preventDefault(); window.IntegraRP?.feedback?.show?.({ type: "warning", title: "Acesso ainda não iniciado", message: "A API exige registro auditável antes de liberar o contexto. Nenhum acesso silencioso foi realizado." }); closeDrawer(); });
  load();
})();
