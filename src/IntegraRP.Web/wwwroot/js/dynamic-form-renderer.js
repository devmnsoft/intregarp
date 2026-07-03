(function () {
    const form = document.getElementById("dynamic-form");
    const shell = document.querySelector(".dynamic-shell[data-module-code]");
    if (!form || !shell) return;
    form.innerHTML = "<div class='dynamic-card'><label class='form-label'>Título</label><input class='form-control' name='titulo' required /><button class='btn btn-primary mt-3'>Salvar</button></div>";
    form.addEventListener("submit", async (event) => {
        event.preventDefault();
        const data = new FormData(form);
        await window.studioApi.createRecord(shell.dataset.moduleCode, { valores: { titulo: data.get("titulo") } });
        window.location.href = `/dynamic/${shell.dataset.moduleCode}`;
    });
})();
