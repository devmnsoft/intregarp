import { showToast } from '../core/feedback-center.js';

document.addEventListener('DOMContentLoaded', () => {
  const page = document.querySelector('[data-page-title]')?.getAttribute('data-page-title') ?? document.title;
  showToast({ type: 'info', title: page, message: 'Tela conectada à jornada comercial v1.29.' });
});
