(async function () {
    const page = document.querySelector("[data-board-id]");
    const board = document.getElementById("kanban-board");
    if (!page || !board) return;
    const boardId = page.dataset.boardId;
    const detail = await (await fetch(`/api/project/boards/${boardId}`)).json();
    board.classList.remove("loading");
    board.innerHTML = detail.colunas.map(column => `<section class="kanban-column" data-column-id="${column.id}"><h2>${column.nome}</h2>${column.itens.map(item => `<article class="kanban-card" draggable="true" data-item-id="${item.id}"><strong>${item.titulo}</strong><span>${item.prioridade}</span><small>${item.storyPoints} pts</small></article>`).join("")}<button class="btn btn-sm btn-outline-primary">Criar card</button></section>`).join("");
    board.addEventListener("dragstart", event => event.dataTransfer.setData("text/plain", event.target.dataset.itemId));
    board.addEventListener("dragover", event => event.preventDefault());
    board.addEventListener("drop", async event => {
        event.preventDefault();
        const column = event.target.closest(".kanban-column");
        const itemId = event.dataTransfer.getData("text/plain");
        if (column && itemId && confirm("Mover card para esta coluna?")) await fetch(`/api/project/items/${itemId}/move`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ colunaId: column.dataset.columnId, ordem: 1 }) });
    });
})();
