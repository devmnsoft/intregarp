document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-onboarding-progress]').forEach((element) => {
    element.setAttribute('aria-label', 'Progresso de onboarding e próxima etapa');
  });
});
