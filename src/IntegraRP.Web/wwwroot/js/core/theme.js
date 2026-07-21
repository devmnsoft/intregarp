"use strict";
(() => { const saved = localStorage.getItem("integrarp.theme") || "system"; document.documentElement.dataset.theme = saved; })();
