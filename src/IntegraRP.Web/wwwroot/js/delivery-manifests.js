(function () {
    const tenantId = localStorage.getItem('tenantId') || '00000000-0000-0000-0000-000000000001';
    async function getJson(url) {
        const response = await fetch(url, { headers: { 'x-tenant-id': tenantId } });
        return response.ok ? response.json() : [];
    }
    function render(target, html) {
        const element = document.querySelector(target);
        if (element) {
            element.innerHTML = html;
        }
    }
    document.addEventListener('DOMContentLoaded', async function () {
        if (document.querySelector('#templateCards')) {
            const templates = await getJson('/api/operational/templates');
            render('#templateCards', templates.map(item => `<article class="op-card"><span class="op-badge">${item.categoria}</span><h3>${item.nome}</h3><p>${item.descricao || ''}</p></article>`).join('') || '<div class="ops-empty">Nenhum template encontrado.</div>');
        }
        if (document.querySelector('#operationsDashboard')) {
            const dashboard = await getJson('/api/operations/deliveries/dashboard');
            render('#operationsDashboard', Object.entries(dashboard).map(([key, value]) => `<div class="ops-card ops-kpi"><strong>${key}</strong><div>${value}</div></div>`).join(''));
        }
        if (document.querySelector('#routesTable')) {
            const routes = await getJson('/api/operations/routes');
            render('#routesTable', routes.map(item => `<div class="ops-card"><strong>${item.codigo}</strong> ${item.nome} - ${item.status}</div>`).join('') || '<div class="ops-empty">Crie a primeira rota de entrega.</div>');
        }
        if (document.querySelector('#manifestsTable')) {
            const manifests = await getJson('/api/operations/manifests');
            render('#manifestsTable', manifests.map(item => `<div class="ops-card"><strong>${item.codigo}</strong> ${item.status}</div>`).join('') || '<div class="ops-empty">Crie o primeiro romaneio.</div>');
        }
        if (document.querySelector('#deliveryMonitoring')) {
            const pending = await getJson('/api/operations/deliveries/pending');
            render('#deliveryMonitoring', pending.map(item => `<div class="ops-card">Parada ${item.ordem}: ${item.enderecoTexto || 'Sem endereço'} (${item.status})</div>`).join('') || '<div class="ops-empty">Nenhuma entrega pendente.</div>');
        }
        if (document.querySelector('#deliveryOccurrences')) {
            const occurrences = await getJson('/api/operations/deliveries/occurrences');
            render('#deliveryOccurrences', occurrences.map(item => `<div class="ops-card"><strong>${item.tipo}</strong> ${item.descricao} - ${item.status}</div>`).join('') || '<div class="ops-empty">Nenhuma ocorrência aberta.</div>');
        }
        if (document.querySelector('#podForm')) {
            render('#podForm', '<label>Recebedor</label><input class="form-control" name="recebedorNome" /><label>Documento</label><input class="form-control" name="recebedorDocumento" /><button class="btn btn-success mt-3" type="button">Registrar POD</button>');
        }
    });
}());
