(() => {
  "use strict";
  const form = document.querySelector(".account-form");
  const password = document.querySelector("#Password");
  const toggle = document.querySelector("[data-password-toggle]");
  const caps = document.querySelector("[data-caps-lock]");
  toggle?.addEventListener("click", () => {
    const visible = password.type === "text";
    password.type = visible ? "password" : "text";
    toggle.setAttribute("aria-pressed", String(!visible));
    toggle.setAttribute("aria-label", visible ? "Mostrar senha" : "Ocultar senha");
    toggle.querySelector("[data-password-toggle-label]").textContent = visible ? "Mostrar" : "Ocultar";
    password.focus();
  });
  password?.addEventListener("keyup", event => { caps.hidden = !event.getModifierState("CapsLock"); });
  password?.addEventListener("blur", () => { caps.hidden = true; });
  form?.addEventListener("submit", event => {
    if (!form.checkValidity()) {
      event.preventDefault(); form.classList.add("was-validated");
      form.querySelector(":invalid")?.focus(); return;
    }
    const button = form.querySelector("[data-submit-button]");
    button.disabled = true; button.setAttribute("aria-busy", "true");
    button.querySelector("[data-submit-label]").textContent = "Validando acesso";
    button.querySelector("[data-submit-spinner]").hidden = false;
  });
})();
