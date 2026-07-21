async function exportProjectBoard(boardId) {
    const response = await fetch(`/api/project/boards/${boardId}/export`, { method: "POST" });
    const data = await response.json();
    navigator.clipboard?.writeText(data.json);
    if (window.IntegraRPToast) window.IntegraRPToast.show({type:"success",title:"Exportação",description:"JSON do board exportado."});
}
