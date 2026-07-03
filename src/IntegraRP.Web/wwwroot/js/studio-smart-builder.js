(function () {
    const button = document.getElementById("smart-suggest");
    const description = document.getElementById("smart-description");
    const result = document.getElementById("smart-result");
    if (!button) return;
    button.addEventListener("click", async () => {
        result.textContent = "Gerando sugestão determinística...";
        const draft = await window.studioApi.suggestModule({ descricao: description.value || "controle de avaria" });
        result.textContent = JSON.stringify(draft, null, 2);
    });
})();
