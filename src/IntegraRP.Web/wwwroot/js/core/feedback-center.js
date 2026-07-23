export function showToast({ type = 'info', title = '', message = '' } = {}) {
  if (window.IntegraRPToast?.show) {
    window.IntegraRPToast.show({ type, title, description: message });
    return;
  }
  const event = new CustomEvent('integrarp:toast', { detail: { type, title, message } });
  window.dispatchEvent(event);
}

window.IntegraRPFeedback = {
  success(title, description) { showToast({ type: 'success', title, message: description }); },
  info(title, description) { showToast({ type: 'info', title, message: description }); },
  warning(title, description) { showToast({ type: 'warning', title, message: description }); },
  error(title, description) { showToast({ type: 'error', title, message: description }); }
};
