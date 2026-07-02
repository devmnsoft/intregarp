import * as SecureStore from 'expo-secure-store';
const tokenKey = 'integrarp.mobile.accessToken';
export async function saveAccessToken(token: string): Promise<void> { await SecureStore.setItemAsync(tokenKey, token); }
export async function getAccessToken(): Promise<string | null> { return SecureStore.getItemAsync(tokenKey); }
export async function clearAccessToken(): Promise<void> { await SecureStore.deleteItemAsync(tokenKey); }
