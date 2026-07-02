async function recalculateOperationalScore() {
    const response = await fetch("/api/bi/score/recalculate", { method: "POST" });
    if (!response.ok) alert("Não foi possível recalcular o score operacional.");
}
