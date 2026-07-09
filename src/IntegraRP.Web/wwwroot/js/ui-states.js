window.IntegraRpUiStates = {
  showLoading(target) { document.querySelector(target)?.setAttribute('data-state', 'loading'); },
  showReady(target) { document.querySelector(target)?.setAttribute('data-state', 'ready'); },
  showEmpty(target) { document.querySelector(target)?.setAttribute('data-state', 'empty'); },
  showError(target, message) {
    const element = document.querySelector(target);
    if (!element) return;
    element.setAttribute('data-state', 'error');
    element.dispatchEvent(new CustomEvent('integrarp:error', { detail: { message } }));
  }
};
