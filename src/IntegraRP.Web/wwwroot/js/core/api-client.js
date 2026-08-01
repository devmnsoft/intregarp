"use strict";

export async function apiRequest(path, options = {}) {
  const token = document.querySelector('input[name="__RequestVerificationToken"]')?.value;
  const headers = new Headers(options.headers || {});
  headers.set('Accept', 'application/json');
  headers.set('X-Correlation-Id', crypto.randomUUID());
  if (options.body && !headers.has('Content-Type')) headers.set('Content-Type', 'application/json');
  if (token) headers.set('RequestVerificationToken', token);

  const response = await fetch(`/api/proxy?path=${encodeURIComponent(path)}`, {
    ...options,
    headers,
    credentials: 'same-origin'
  });
  if (!response.ok) {
    const problem = await response.json().catch(() => ({}));
    const error = new Error(problem.detail || problem.title || 'Não foi possível concluir a operação.');
    error.status = response.status;
    error.correlationId = problem.correlation_id || problem.extensions?.correlation_id;
    throw error;
  }
  return response.status === 204 ? null : response.json();
}
