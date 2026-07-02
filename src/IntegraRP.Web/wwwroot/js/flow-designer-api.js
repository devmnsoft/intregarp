(function () {
  "use strict";
  const root = window.FlowDesigner = window.FlowDesigner || {};
  async function request(url, options) {
    const response = await fetch(url, Object.assign({ headers: { "Content-Type": "application/json" } }, options || {}));
    if (response.status === 401 || response.status === 403) { throw new Error("Sessão sem permissão para acessar o Flow Designer."); }
    if (!response.ok) { const problem = await response.json().catch(function () { return {}; }); throw new Error(problem.detail || "Falha na comunicação com a API."); }
    if (response.status === 204) { return null; }
    return response.json();
  }
  root.api = {
    listTemplates: function () { return request("/api/flow/designer/templates"); },
    cloneTemplate: function (id, payload) { return request("/api/flow/designer/templates/" + id + "/clone", { method: "POST", body: JSON.stringify(payload) }); },
    getVersion: function (id) { return request("/api/flow/designer/versions/" + id); },
    saveLayout: function (id, payload) { return request("/api/flow/designer/versions/" + id + "/layout", { method: "PUT", body: JSON.stringify(payload) }); },
    addElement: function (id, payload) { return request("/api/flow/designer/versions/" + id + "/elements", { method: "POST", body: JSON.stringify(payload) }); },
    updateElement: function (versionId, elementId, payload) { return request("/api/flow/designer/versions/" + versionId + "/elements/" + elementId, { method: "PUT", body: JSON.stringify(payload) }); },
    validate: function (id) { return request("/api/flow/designer/versions/" + id + "/validate", { method: "POST" }); },
    publish: function (id, payload) { return request("/api/flow/designer/versions/" + id + "/publish", { method: "POST", body: JSON.stringify(payload) }); },
    history: function (id) { return request("/api/flow/designer/versions/" + id + "/history"); }
  };
}());
