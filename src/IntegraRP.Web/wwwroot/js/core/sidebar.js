"use strict";
(() => {
  const shell = document.querySelector("[data-shell]");
  const toggleButtons = document.querySelectorAll("[data-sidebar-toggle]");
  const overlay = document.querySelector("[data-sidebar-overlay]");
  const setOpen = (open) => shell?.classList.toggle("sidebar-open", open);
  toggleButtons.forEach((button) => button.addEventListener("click", () => setOpen(!shell?.classList.contains("sidebar-open"))));
  overlay?.addEventListener("click", () => setOpen(false));
  document.addEventListener("keydown", (event) => { if (event.key === "Escape") setOpen(false); });
})();
