(async function () {
    const list = document.getElementById("project-boards");
    if (list) {
        const boards = await (await fetch("/api/project/boards")).json();
        list.innerHTML = boards.map(board => `<article class="project-board-card"><h2>${board.nome}</h2><p>${board.descricao}</p><a class="btn btn-primary" href="/project/boards/${board.id}/kanban">Abrir Kanban</a></article>`).join("");
    }
    const form = document.getElementById("project-board-form");
    if (form) form.addEventListener("submit", async event => {
        event.preventDefault();
        const body = Object.fromEntries(new FormData(form));
        body.criarColunasPadrao = body.criarColunasPadrao === "on";
        const response = await fetch("/api/project/boards", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
        const board = await response.json();
        location.href = `/project/boards/${board.id}/kanban`;
    });
})();
