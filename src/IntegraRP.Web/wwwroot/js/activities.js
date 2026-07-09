(async function(){
  const status=document.getElementById('activities-status'), grid=document.getElementById('activities-grid');
  try { const data=await fetch('/api/proxy?path=/api/activities').then(r=>r.ok?r.json():fetch('/api/activities').then(x=>x.json()));
    status.textContent=`${data.length} atividades carregadas`; status.className='alert alert-success';
    grid.innerHTML=data.map(a=>`<div class="col-md-4"><article class="card h-100 p-3"><small>${a.modulo} · ${a.status}</small><h3>${a.titulo}</h3><p>${a.descricao}</p><p><code>${a.permissao}</code></p><a class="btn btn-primary" href="${a.rotaWeb}">Abrir</a></article></div>`).join('');
  } catch(e){ status.textContent='Erro ao carregar atividades: '+e; status.className='alert alert-danger'; grid.innerHTML='<p>Estado vazio: nenhuma atividade disponível.</p>'; }
})();
