(function () {
    const shell = document.querySelector(".dynamic-shell[data-module-code]");
    const target = document.getElementById("dynamic-list");
    if (!shell || !target) return;
    target.innerHTML = "<div class='dynamic-card'>Carregando registros...</div>";
    window.studioApi.listRecords(shell.dataset.moduleCode).then((records) => {
        if (!records.length) { target.innerHTML = "<div class='dynamic-card'>Nenhum registro encontrado.</div>"; return; }
        target.innerHTML = records.map((record) => `<a class='dynamic-card d-block' href='/dynamic/${shell.dataset.moduleCode}/${record.id}'>${record.id}</a>`).join("");
    }).catch((error) => { target.innerHTML = `<div class='dynamic-card text-danger'>${error.message}</div>`; });
})();
