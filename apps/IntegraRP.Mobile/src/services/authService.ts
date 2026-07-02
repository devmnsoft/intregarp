import { apiRequest } from './apiClient';
import { saveAccessToken, clearAccessToken } from '../storage/secureTokenStorage';
export type LoginResponse = { accessToken: string; tenantId: string; usuarioId: string; nome: string };
export async function login(email: string, senha: string, tenantSlug: string): Promise<LoginResponse> { const data = await apiRequest<LoginResponse>('/api/mobile/auth/login', { method: 'POST', body: JSON.stringify({ email, senha, tenantSlug }) }); await saveAccessToken(data.accessToken); return data; }
export async function logout(): Promise<void> { await clearAccessToken(); }
