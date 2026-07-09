window.IntegraRpApiErrorHandler = {
  handle(response) {
    if (response.status === 401) window.location.href = '/login';
    if (response.status === 403) throw new Error('Acesso negado para esta operação.');
    if (!response.ok) throw new Error(`Falha ao chamar API IntegraRP (${response.status}).`);
    return response;
  }
};
