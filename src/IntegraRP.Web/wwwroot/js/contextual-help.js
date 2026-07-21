window.showContextualHelp = function showContextualHelp(screen) {
  if (window.IntegraRPToast) window.IntegraRPToast.show({type:"info",title:"Como usar",description:`Tela ${screen}: revise os campos e execute a próxima ação recomendada.`});
};
