window.renderEmptyStateGuidance = function renderEmptyStateGuidance(target, message, actionLabel) {
  target.innerHTML = `<div class="empty-state"><h2>${message}</h2><button>${actionLabel}</button><a href="/journey/help">Ajuda</a></div>`;
};
