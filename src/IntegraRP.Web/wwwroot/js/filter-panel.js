// IntegraRP v1.8 filter-panel: helper funcional sem minificação.
window.IntegraRP = window.IntegraRP || {};
window.IntegraRP['filter-panel'] = {
    init() {
        document.dispatchEvent(new CustomEvent('integrarp:filter-panel:ready'));
    }
};

document.addEventListener('DOMContentLoaded', () => window.IntegraRP['filter-panel'].init());
