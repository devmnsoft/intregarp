import { apiRequest } from './apiClient';
export type MobileTask = { id: string; titulo: string; processo: string; prazo?: string; prioridade: string; status: string; proximaAcao: string };
export function listTasks(): Promise<MobileTask[]> { return apiRequest<MobileTask[]>('/api/mobile/tasks'); }
export function completeTask(id: string): Promise<unknown> { return apiRequest(`/api/mobile/tasks/${id}/complete`, { method: 'POST', body: JSON.stringify({}) }); }
