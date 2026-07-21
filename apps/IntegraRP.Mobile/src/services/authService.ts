import { apiRequest } from './apiClient';
import { clearSession, saveSession } from '../storage/secureTokenStorage';

export type LoginResponse = { accessToken: string; refreshToken: string; expiresAt: string; usuario: unknown; tenant: unknown; perfis: string[]; permissoes: string[] };

export async function login(email: string, password: string, tenantSlug: string, deviceId?: string, deviceName?: string): Promise<LoginResponse> {
  const data = await apiRequest<LoginResponse>('/api/auth/login', { method: 'POST', body: JSON.stringify({ tenantSlug, email, password, deviceId, deviceName }) });
  await saveSession({ accessToken: data.accessToken, refreshToken: data.refreshToken, expiresAt: data.expiresAt, usuario: data.usuario, tenant: data.tenant });
  return data;
}

export async function logout(): Promise<void> { try { await apiRequest<void>('/api/auth/logout', { method: 'POST', body: JSON.stringify({ allSessions: false }) }); } finally { await clearSession(); } }
