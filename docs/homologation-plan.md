# Plano de homologação do piloto v1.0

## Escopo
Homologar os fluxos de Login/Admin, Flow/BPMN, Studio, Comercial, Estoque, Pedidos, Faturamento, Connect, BI, Project, Mobile, Operações, IA governada, LGPD e Auditoria.

## Ambiente
Ambiente piloto isolado com tenant **Valora Group & MNSoft Demo**, dados demo da migration `0012_piloto_v1_final_adjustments.sql`, API, Web, Worker e PostgreSQL.

## Participantes
Administrador, gestor, vendas, financeiro, logística, motorista/promotor, auditor LGPD e responsável técnico.

## Massa de dados
Usar as contas de `docs/pilot-demo-credentials.md` e os cenários demo de cliente, produto, pedido, fatura, outbox, board, rota, romaneio, POD e IA.

## Critérios de aprovação
Build e testes verdes, smoke test OK, fluxos críticos concluídos, sem bug bloqueante ou crítico aberto, aceite formal registrado.

## Critérios de reprovação
Falha de autenticação, isolamento por tenant, RBAC, LGPD, processamento de pedido/fatura/outbox, perda de dados ou indisponibilidade recorrente.

## Registro de bugs
Registrar módulo, usuário, passo, resultado esperado, resultado obtido, evidência, severidade, responsável e prazo.

## Severidade
- Bloqueante: impede homologação.
- Crítica: compromete fluxo principal.
- Média: possui contorno operacional.
- Baixa: ajuste visual ou melhoria.

## Assinatura de aceite
Aceite deve conter data, versão, responsáveis, pendências aceitas e decisão de go-live ou novo ciclo.
