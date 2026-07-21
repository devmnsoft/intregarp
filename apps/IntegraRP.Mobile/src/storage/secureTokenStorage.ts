import * as SecureStore from 'expo-secure-store';

const keys = {
  accessToken: 'integrarp.mobile.accessToken',
  refreshToken: 'integrarp.mobile.refreshToken',
  expiresAt: 'integrarp.mobile.expiresAt',
  usuario: 'integrarp.mobile.usuario',
  tenant: 'integrarp.mobile.tenant',
};

export type StoredSession = {
  accessToken: string;
  refreshToken: string;
  expiresAt: string;
  usuario?: unknown;
  tenant?: unknown;
};

export async function saveSession(session: StoredSession): Promise<void> {
  await SecureStore.setItemAsync(keys.accessToken, session.accessToken);
  await SecureStore.setItemAsync(keys.refreshToken, session.refreshToken);
  await SecureStore.setItemAsync(keys.expiresAt, session.expiresAt);
  if (session.usuario) await SecureStore.setItemAsync(keys.usuario, JSON.stringify(session.usuario));
  if (session.tenant) await SecureStore.setItemAsync(keys.tenant, JSON.stringify(session.tenant));
}

export async function getAccessToken(): Promise<string | null> { return SecureStore.getItemAsync(keys.accessToken); }
export async function getRefreshToken(): Promise<string | null> { return SecureStore.getItemAsync(keys.refreshToken); }
export async function getExpiresAt(): Promise<string | null> { return SecureStore.getItemAsync(keys.expiresAt); }
export async function clearSession(): Promise<void> { await Promise.all(Object.values(keys).map((key) => SecureStore.deleteItemAsync(key))); }
