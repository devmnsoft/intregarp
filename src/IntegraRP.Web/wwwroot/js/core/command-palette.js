"use strict";
(() => {
  const palette = document.querySelector("[data-command-palette]");
  const input = document.querySelector("[data-command-input]");
  const open = () => { if (!palette) return; palette.hidden = false; setTimeout(() => input?.focus(), 0); };
  const close = () => { if (palette) palette.hidden = true; };
  document.querySelectorAll("[data-command-open]").forEach((el) => el.addEventListener("click", open));
  document.addEventListener("keydown", (event) => { if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k") { event.preventDefault(); open(); } if (event.key === "Escape") close(); });
  palette?.addEventListener("click", (event) => { if (event.target === palette) close(); });
})();
