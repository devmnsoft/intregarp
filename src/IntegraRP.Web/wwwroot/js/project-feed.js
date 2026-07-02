(async function () {
    const page = document.querySelector("[data-board-id]");
    const target = document.getElementById("project-feed");
    if (!page || !target) return;
    const feed = await (await fetch(`/api/project/boards/${page.dataset.boardId}/feed`)).json();
    target.innerHTML = `<h2>Feed</h2>${feed.map(x => `<p><strong>${x.tipo}</strong><br>${x.descricao}</p>`).join("")}`;
})();
