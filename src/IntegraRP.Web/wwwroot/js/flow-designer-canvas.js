(function () {
  "use strict";
  const root = window.FlowDesigner;
  function render() {
    const canvas = document.getElementById("flow-canvas");
    const lines = document.getElementById("flow-lines");
    if (!canvas || !root.state.version) { return; }
    canvas.innerHTML = "";
    lines.innerHTML = "";
    root.state.version.elements.forEach(function (element) {
      const node = document.createElement("button");
      node.type = "button";
      node.className = "flow-node " + element.tipo;
      node.style.left = element.posicaoX + "px";
      node.style.top = element.posicaoY + "px";
      node.innerHTML = "<strong>" + element.nome + "</strong><br><small>" + element.tipo + "</small>";
      node.addEventListener("click", function () { root.state.selectElement(element); if (root.elements) { root.elements.fillForm(element); } render(); });
      if (root.state.selectedElement && root.state.selectedElement.id === element.id) { node.classList.add("selected"); }
      canvas.appendChild(node);
    });
    root.state.version.transitions.forEach(function (transition) {
      const source = root.state.version.elements.find(function (x) { return x.id === transition.elementoOrigemId; });
      const target = root.state.version.elements.find(function (x) { return x.id === transition.elementoDestinoId; });
      if (!source || !target) { return; }
      const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
      line.setAttribute("x1", source.posicaoX + 190);
      line.setAttribute("y1", source.posicaoY + 40);
      line.setAttribute("x2", target.posicaoX);
      line.setAttribute("y2", target.posicaoY + 40);
      line.setAttribute("stroke", "#071F3A");
      line.setAttribute("stroke-width", "2");
      lines.appendChild(line);
    });
    document.getElementById("flow-technical-json").textContent = JSON.stringify(root.state.version, null, 2);
  }
  root.canvas = { render: render };
}());
