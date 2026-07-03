(function () {
    const modulesContainer = document.getElementById("studio-modules");
    const createForm = document.getElementById("studio-create-module-form");
    function showToast(message) { console.log(message); }
    if (modulesContainer) {
        modulesContainer.innerHTML = "<div class='studio-card'>Carregando módulos...</div>";
        window.studioApi.listModules().then((modules) => {
            if (!modules.length) { modulesContainer.innerHTML = `<div class='studio-card'>${modulesContainer.dataset.empty}</div>`; return; }
            modulesContainer.innerHTML = modules.map((module) => `<article class='studio-card'><h2>${module.nome}</h2><p>${module.codigo}</p><a class='btn btn-sm btn-primary' href='/studio/modules/${module.id}/builder'>Abrir builder</a></article>`).join("");
        }).catch((error) => { modulesContainer.innerHTML = `<div class='studio-card text-danger'>${error.message}</div>`; });
    }
    if (createForm) {
        createForm.addEventListener("submit", async (event) => {
            event.preventDefault();
            const data = new FormData(createForm);
            const payload = { nome: data.get("nome"), codigo: data.get("codigo"), icone: data.get("icone"), cor: data.get("cor") };
            const module = await window.studioApi.createModule(payload);
            showToast("Módulo criado com sucesso.");
            window.location.href = `/studio/modules/${module.id}/builder`;
        });
    }
})();
