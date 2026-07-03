window.studioApi = (() => {
    async function request(url, options = {}) {
        const response = await fetch(url, {
            headers: { "Content-Type": "application/json", ...(options.headers || {}) },
            credentials: "same-origin",
            ...options
        });
        if (response.status === 401 || response.status === 403) {
            throw new Error("Acesso negado. Verifique autenticação e permissões.");
        }
        if (!response.ok) {
            const problem = await response.text();
            throw new Error(problem || "Falha na API do Studio.");
        }
        return response.status === 204 ? null : response.json();
    }
    return {
        listModules: () => request("/api/proxy?path=/api/studio/modules"),
        createModule: (payload) => request("/api/proxy?path=/api/studio/modules", { method: "POST", body: JSON.stringify(payload) }),
        suggestModule: (payload) => request("/api/proxy?path=/api/studio/suggest-module", { method: "POST", body: JSON.stringify(payload) }),
        listRecords: (moduleCode) => request(`/api/proxy?path=/api/dynamic/${encodeURIComponent(moduleCode)}`),
        createRecord: (moduleCode, payload) => request(`/api/proxy?path=/api/dynamic/${encodeURIComponent(moduleCode)}`, { method: "POST", body: JSON.stringify(payload) })
    };
})();
