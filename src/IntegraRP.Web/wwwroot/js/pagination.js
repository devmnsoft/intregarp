// IntegraRP v1.8 pagination: helper funcional sem minificação.
window.IntegraRP = window.IntegraRP || {};
window.IntegraRP['pagination'] = {
    init() {
        document.dispatchEvent(new CustomEvent('integrarp:pagination:ready'));
    }
};

document.addEventListener('DOMContentLoaded', () => window.IntegraRP['pagination'].init());
