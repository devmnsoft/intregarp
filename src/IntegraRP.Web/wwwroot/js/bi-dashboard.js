(async function () {
    const page = document.querySelector("[data-dashboard]");
    if (!page) return;
    const dashboard = page.dataset.dashboard || "executive";
    const url = dashboard === "executive" ? "/api/bi/dashboard/executive" : `/api/bi/dashboard/${dashboard}`;
    const response = await fetch(url);
    if (response.status === 401 || response.status === 403) { if (window.IntegraRPToast) window.IntegraRPToast.show({type:"error",title:"Acesso negado",description:"Verifique suas permissões."}); return; }
    const data = await response.json();
    const cards = data.cards || [];
    document.getElementById("bi-cards").innerHTML = cards.map(card => `<article class="bi-card status-${card.status}"><span>${card.icone}</span><h3>${card.titulo}</h3><strong>${card.valor}</strong><small>${card.unidade}</small></article>`).join("");
    if (data.score) document.getElementById("bi-score").innerHTML = `<h2>Score operacional</h2><strong>${data.score.score}</strong><span>${data.score.status}</span>`;
    const charts = document.getElementById("bi-charts");
    charts.innerHTML = (data.charts || []).map((chart, index) => `<article class="bi-chart"><h3>${chart.titulo}</h3><div id="chart-${index}"></div></article>`).join("");
    (data.charts || []).forEach((chart, index) => SimpleCharts[chart.tipo === "linha" ? "line" : "bars"](document.getElementById(`chart-${index}`), chart));
    const alerts = document.getElementById("bi-alerts");
    if (alerts) alerts.innerHTML = [...(data.gargalos || []), ...(data.alertas || []).map(a => a.mensagem)].map(x => `<li>${x}</li>`).join("");
})();
