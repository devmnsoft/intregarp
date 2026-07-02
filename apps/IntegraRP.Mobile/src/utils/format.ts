export function formatConfidence(value?: number): string { return value == null ? '-' : `${Math.round(value * 100)}%`; }
