window.IntegraRpUiStates = {
  showLoading(target) { document.querySelector(target)?.setAttribute('data-state', 'loading'); },
  showReady(target) { document.querySelector(target)?.setAttribute('data-state', 'ready'); },
  showEmpty(target) { document.querySelector(target)?.setAttribute('data-state', 'empty'); },
  showUnauthorized(target) { document.querySelector(target)?.setAttribute('data-state', 'unauthorized'); },
  showForbidden(target) { document.querySelector(target)?.setAttribute('data-state', 'forbidden'); },
  showError(target, message) {
    const element = document.querySelector(target);
    if (!element) return;
    element.setAttribute('data-state', 'error');
    element.dispatchEvent(new CustomEvent('integrarp:error', { detail: { message } }));
  }
};
