async function exportProjectBoard(boardId) {
    const response = await fetch(`/api/project/boards/${boardId}/export`, { method: "POST" });
    const data = await response.json();
    navigator.clipboard?.writeText(data.json);
    alert("JSON do board exportado.");
}
