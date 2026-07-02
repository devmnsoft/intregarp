const pendingItems: Array<{ type: string; payload: unknown }> = [];
export function queueForFutureSync(type: string, payload: unknown): void { pendingItems.push({ type, payload }); }
export function getPendingSyncCount(): number { return pendingItems.length; }
