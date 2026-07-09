// IntegraRP v1.8 toast: helper funcional sem minificação.
window.IntegraRP = window.IntegraRP || {};
window.IntegraRP['toast'] = {
    init() {
        document.dispatchEvent(new CustomEvent('integrarp:toast:ready'));
    }
};

document.addEventListener('DOMContentLoaded', () => window.IntegraRP['toast'].init());
