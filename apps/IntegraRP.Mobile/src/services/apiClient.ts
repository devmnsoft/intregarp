import { getAccessToken } from '../storage/secureTokenStorage';
const apiBaseUrl = process.env.EXPO_PUBLIC_API_BASE_URL ?? 'http://localhost:5000';
export async function apiRequest<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = await getAccessToken();
  const response = await fetch(`${apiBaseUrl}${path}`, { ...options, headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(options.headers ?? {}) } });
  if (!response.ok) { throw new Error(`API ${response.status}: ${await response.text()}`); }
  return response.json() as Promise<T>;
}
