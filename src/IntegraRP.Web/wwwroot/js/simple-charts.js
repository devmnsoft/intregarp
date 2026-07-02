window.SimpleCharts = {
    bars(container, chart) {
        const max = Math.max(...chart.valores, 1);
        container.innerHTML = chart.labels.map((label, index) => `
            <div class="simple-bar-row">
                <span>${label}</span>
                <div class="simple-bar-track"><div class="simple-bar-fill" style="width:${(chart.valores[index] / max) * 100}%"></div></div>
                <strong>${chart.valores[index]}</strong>
            </div>`).join("");
    },
    line(container, chart) {
        const max = Math.max(...chart.valores, 1);
        const points = chart.valores.map((value, index) => `${(index / Math.max(chart.valores.length - 1, 1)) * 100},${100 - ((value / max) * 90)}`).join(" ");
        container.innerHTML = `<svg viewBox="0 0 100 100" class="simple-line"><polyline points="${points}" /></svg>`;
    },
    progress(container, value) {
        container.innerHTML = `<div class="simple-progress"><span style="width:${value}%"></span></div>`;
    }
};
