(() => {
  "use strict";
  const refresh = document.querySelector("[data-refresh-dashboard]");
  if (!refresh) return;
  let controller;
  refresh.addEventListener("click", async () => {
    controller?.abort();
    controller = new AbortController();
    refresh.disabled = true;
    refresh.setAttribute("aria-busy", "true");
    try {
      const response = await fetch("/api/commercial/dashboard", { credentials: "same-origin", headers: { Accept: "application/json" }, signal: controller.signal });
      if (response.status === 401) { window.location.assign("/account/session-expired"); return; }
      if (!response.ok) throw new Error(`Dashboard indisponível (${response.status}).`);
      window.location.reload();
    } catch (error) {
      if (error.name !== "AbortError") window.IntegraRPFeedback?.error?.(error.message);
    } finally {
      refresh.disabled = false;
      refresh.removeAttribute("aria-busy");
    }
  });
})();
