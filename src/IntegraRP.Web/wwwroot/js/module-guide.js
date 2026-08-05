(function () {
  "use strict";

  document.querySelectorAll("[data-module-guide]").forEach((guide) => {
    const key = `integrarp:module-guide:${guide.dataset.moduleGuide}`;
    const toggle = guide.querySelector("[data-module-guide-toggle]");
    const state = guide.querySelector(".app-module-guide__state");
    const apply = (collapsed) => {
      guide.classList.toggle("is-collapsed", collapsed);
      toggle?.setAttribute("aria-expanded", String(!collapsed));
      if (state) state.textContent = collapsed ? "Expandir" : "Recolher";
    };
    apply(localStorage.getItem(key) === "collapsed");
    toggle?.addEventListener("click", () => {
      const collapsed = !guide.classList.contains("is-collapsed");
      localStorage.setItem(key, collapsed ? "collapsed" : "expanded");
      apply(collapsed);
    });
  });
}());
