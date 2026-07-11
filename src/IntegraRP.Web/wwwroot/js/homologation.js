(async function(){
  const api=window.api||((u,o)=>fetch(u,{headers:{'Content-Type':'application/json'},...(o||{})}).then(r=>{if(!r.ok)throw new Error(r.statusText);return r.json();}));
  const status=document.getElementById('homologation-status'), body=document.getElementById('homologation-checks');
  async function load(run){
    try{ const data=await api(run?'/api/homologation/run-all':'/api/homologation/status',{method:run?'POST':'GET'}); const checks=data.checks||data.Checks||[];
      status.textContent=`Status geral: ${data.status||data.Status}. ${checks.length} check(s) carregado(s).`; status.className='alert alert-'+((data.status||'warning')==='ok'?'success':'warning');
      body.innerHTML=checks.map(c=>`<tr><td>${c.title||c.Title}</td><td><span class="badge text-bg-${(c.status||c.Status)==='ok'?'success':'warning'}">${c.status||c.Status}</span></td><td>${c.detail||c.Detail||''}${c.error||c.Error?'<br><small class="text-danger">'+(c.error||c.Error)+'</small>':''}</td><td>${c.nextAction||c.NextAction||''}</td><td><a class="btn btn-sm btn-outline-primary" href="${c.route||c.Route}">Abrir</a> <button class="btn btn-sm btn-outline-secondary" data-check="${c.code||c.Code}">Validar</button></td></tr>`).join('')||'<tr><td colspan="5">Nenhum check encontrado.</td></tr>';
    }catch(e){ status.textContent='Erro ao carregar homologação: '+e.message; status.className='alert alert-danger'; }
  }
  document.getElementById('homologation-run-all')?.addEventListener('click',()=>load(true));
  document.addEventListener('click',async ev=>{ if(ev.target.dataset.check){ await api('/api/homologation/run-check/'+ev.target.dataset.check,{method:'POST'}); await load(false); }});
  await load(false);
})();
