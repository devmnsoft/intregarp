async function recalculateOperationalScore() {
    const response = await fetch("/api/bi/score/recalculate", { method: "POST" });
    if (!response.ok && window.IntegraRPToast) window.IntegraRPToast.show({type:"error",title:"Score operacional",description:"Não foi possível recalcular o score operacional."});
}
