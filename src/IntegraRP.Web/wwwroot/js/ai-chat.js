(function () {
  const root = document.getElementById('ai-console-root');
  if (!root) return;
  root.insertAdjacentHTML('beforeend', '<div class="ai-message mt-3">Chat IA pronto para enviar mensagens à API /api/ai/conversations/{id}/messages.</div>');
})();
