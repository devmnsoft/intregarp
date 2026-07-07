# Functional Gap Analysis v1.2

Revisão funcional para Jornada do Cliente, onboarding guiado, UX operacional e prontidão funcional.

| Área | Já existe | Incompleto / mock / risco | Prioridade |
| --- | --- | --- | --- |
| Login | Tela de login web e autenticação base. | Falta orientação pós-login e checklist inicial. | Alta |
| Tenant | Middleware e cabeçalho de tenant. | Usuário não entende quando tenant está ausente. | Alta |
| Dashboard | Páginas e KPIs. | Precisa consolidar “O que fazer agora”, alertas e próxima ação. | Alta |
| Core/Admin | Usuários, setores e configurações. | Fluxo não conduz empresa > setores > usuários > permissões. | Alta |
| Flow | BPMN, tarefas e designer. | Primeiro processo e teste precisam de tour. | Alta |
| Studio | Módulos dinâmicos e builder. | Publicação e primeiro registro precisam de passos guiados. | Média |
| Form Builder | Builder avançado. | Ajuda contextual e estados vazios ainda necessários. | Média |
| Automações | Regras e execuções. | Providers reais e tratamento de erro operacional futuros. | Média |
| Comercial | Clientes/pedidos base. | Orientar criação de cliente/produto antes do pedido. | Alta |
| Estoque | Produto/saldo operacional. | Fluxo de entrada inicial e estoque crítico precisam de destaque. | Alta |
| Pedidos | Pedido e faturamento. | Próximos passos para confirmar/faturar precisam estar visíveis. | Alta |
| Faturamento | Títulos, documentos e fake providers. | Boleto/DANFE fake devem ser identificados como sandbox. | Média |
| Connect | Templates/outbox. | Reprocessamento de erro precisa virar ação recomendada. | Média |
| BI/KPIs | Score e relatórios. | Adoção e gargalos por perfil precisam de views próprias. | Alta |
| Project | Boards, sprints e cards. | Não há jornada de ação corretiva para gestor. | Média |
| Mobile | App e offline sync. | Telas de próxima tarefa, ajuda, sync e conflito precisam guia. | Alta |
| IA | Chat, auditoria e ferramentas. | Novas intenções de ajuda devem usar use cases e RBAC. | Alta |
| Operações/Entrega | Rotas, ocorrências e POD. | Falta instrução passo a passo para campo. | Alta |
| Relatórios | Exportáveis. | Próxima ação e exemplos de relatório por perfil. | Média |
| Notificações | Central e eventos. | Geração diária de próximas ações no worker. | Alta |
| Anexos | Evidências avançadas. | Ajuda para foto/GPS/assinatura no mobile. | Média |
| Auditoria/LGPD | Checklists e auditoria. | Auditar respostas da IA e feedback da jornada. | Alta |

## Riscos para o cliente final
- Telas vazias sem CTA geram abandono.
- Providers fake podem ser confundidos com integrações reais.
- Falta de próximo responsável/SLA reduz adoção.
- Erros de outbox, automação e sincronização precisam virar ações corrigíveis.
