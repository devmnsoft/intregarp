import { apiRequest } from './apiClient';
export function uploadEvidence(taskId: string, tipo: string, descricao: string): Promise<unknown> { return apiRequest(`/api/mobile/tasks/${taskId}/evidences`, { method: 'POST', body: JSON.stringify({ tipo, descricao }) }); }
