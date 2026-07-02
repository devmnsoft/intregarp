import { apiRequest } from './apiClient';
export function listNotifications(): Promise<unknown[]> { return apiRequest<unknown[]>('/api/mobile/notifications'); }
