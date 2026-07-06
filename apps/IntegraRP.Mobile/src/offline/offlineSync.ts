export type OfflineQueueItem = { id: string; tenantId: string; type: "task" | "checklist" | "evidence" | "pod" | "visit" | "occurrence"; payload: unknown; createdAt: string; retries: number };
export type OfflineConflict = { id: string; entityId: string; strategy?: "server_wins" | "client_wins" | "manual" | "merge_simple" };

export class OfflineSyncQueue {
  private readonly items: OfflineQueueItem[] = [];
  enqueue(item: OfflineQueueItem): void { this.items.push(item); }
  pending(): readonly OfflineQueueItem[] { return this.items.filter(item => item.retries < 5); }
  markSent(id: string): void { const index = this.items.findIndex(item => item.id === id); if (index >= 0) this.items.splice(index, 1); }
}

export function resolveOfflineConflict(conflict: OfflineConflict, strategy: NonNullable<OfflineConflict["strategy"]>): OfflineConflict {
  return { ...conflict, strategy };
}
