// IntegraRP v1.8 modal-confirm: helper funcional sem minificação.
window.IntegraRP = window.IntegraRP || {};
window.IntegraRP['modal-confirm'] = {
    init() {
        document.dispatchEvent(new CustomEvent('integrarp:modal-confirm:ready'));
    }
};

document.addEventListener('DOMContentLoaded', () => window.IntegraRP['modal-confirm'].init());
