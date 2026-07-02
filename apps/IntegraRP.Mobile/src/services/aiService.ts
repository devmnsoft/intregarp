import { apiRequest } from './apiClient';
export type AiReply = { resposta: string; intencaoCodigo: string; ferramentaCodigo?: string; confianca: number; fallbackHumano: boolean };
export function sendAiMessage(conversationId: string, mensagem: string): Promise<AiReply> { return apiRequest<AiReply>(`/api/ai/conversations/${conversationId}/messages`, { method: 'POST', body: JSON.stringify({ mensagem, canal: 'mobile', permissoes: ['ai.tool.order_status'] }) }); }
