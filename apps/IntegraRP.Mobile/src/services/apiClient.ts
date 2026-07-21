import { clearSession, getAccessToken, getExpiresAt, getRefreshToken, saveSession } from '../storage/secureTokenStorage';

const configuredBaseUrl = process.env.EXPO_PUBLIC_API_BASE_URL;
const isDev = process.env.NODE_ENV !== 'production';
const apiBaseUrl = configuredBaseUrl ?? (isDev ? 'http://10.0.2.2:5000' : undefined);
let refreshInFlight: Promise<string | null> | null = null;

export class ApiProblemError extends Error {
  constructor(public status: number, message: string, public details?: unknown) { super(message); }
}

function requireBaseUrl(): string {
  if (!apiBaseUrl) throw new ApiProblemError(0, 'EXPO_PUBLIC_API_BASE_URL é obrigatório fora de Development.');
  return apiBaseUrl;
}

async function parseError(response: Response): Promise<ApiProblemError> {
  const text = await response.text();
  try { const problem = JSON.parse(text); return new ApiProblemError(response.status, problem.title ?? `API ${response.status}`, problem); } catch { return new ApiProblemError(response.status, text || `API ${response.status}`); }
}

async function refreshAccessToken(): Promise<string | null> {
  if (refreshInFlight) return refreshInFlight;
  refreshInFlight = (async () => {
    const refreshToken = await getRefreshToken();
    if (!refreshToken) return null;
    const response = await fetch(`${requireBaseUrl()}/api/auth/refresh`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ refreshToken }) });
    if (!response.ok) { await clearSession(); return null; }
    const data = await response.json();
    await saveSession({ accessToken: data.accessToken, refreshToken: data.refreshToken, expiresAt: data.expiresAt, usuario: data.usuario, tenant: data.tenant });
    return data.accessToken as string;
  })().finally(() => { refreshInFlight = null; });
  return refreshInFlight;
}

async function getValidAccessToken(): Promise<string | null> {
  const token = await getAccessToken();
  const expiresAt = await getExpiresAt();
  if (!token || !expiresAt) return token;
  if (Date.parse(expiresAt) - Date.now() < 60_000) return refreshAccessToken();
  return token;
}

export async function apiRequest<T>(path: string, options: RequestInit = {}, retry = true): Promise<T> {
  const token = await getValidAccessToken();
  const response = await fetch(`${requireBaseUrl()}${path}`, { ...options, headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(options.headers ?? {}) } });
  if (response.status === 401 && retry && await refreshAccessToken()) return apiRequest<T>(path, options, false);
  if (!response.ok) throw await parseError(response);
  if (response.status === 204) return undefined as T;
  return response.json() as Promise<T>;
}
