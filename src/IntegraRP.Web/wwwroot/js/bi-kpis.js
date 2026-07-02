(async function () {
    const target = document.getElementById("bi-list");
    if (!target) return;
    const response = await fetch("/api/bi/kpis");
    const data = await response.json();
    target.classList.remove("loading");
    target.innerHTML = `<table class="table"><thead><tr><th>Código</th><th>Nome</th><th>Módulo</th><th>Status</th></tr></thead><tbody>${data.map(k => `<tr><td>${k.codigo}</td><td>${k.nome}</td><td>${k.modulo}</td><td>${k.status}</td></tr>`).join("")}</tbody></table>`;
})();
