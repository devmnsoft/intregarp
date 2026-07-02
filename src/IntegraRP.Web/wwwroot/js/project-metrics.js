(async function () {
    const page = document.querySelector("[data-board-id]");
    const target = document.getElementById("project-content");
    if (!page || !target) return;
    const metrics = await (await fetch(`/api/project/boards/${page.dataset.boardId}/metrics`)).json();
    target.classList.remove("loading");
    target.innerHTML = `<h2>Progresso ${metrics.progressoPercentual}%</h2><div id="project-progress"></div><p>${metrics.itensConcluidos}/${metrics.totalItens} itens concluídos · ${metrics.storyPointsConcluidos}/${metrics.storyPointsTotais} pontos</p>`;
    SimpleCharts.progress(document.getElementById("project-progress"), metrics.progressoPercentual);
})();
