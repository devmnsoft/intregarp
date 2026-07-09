// IntegraRP v1.8 crud-list: helper funcional sem minificação.
window.IntegraRP = window.IntegraRP || {};
window.IntegraRP['crud-list'] = {
    init() {
        document.dispatchEvent(new CustomEvent('integrarp:crud-list:ready'));
    }
};

document.addEventListener('DOMContentLoaded', () => window.IntegraRP['crud-list'].init());
