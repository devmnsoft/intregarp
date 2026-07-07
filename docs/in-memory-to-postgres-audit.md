# Auditoria InMemory/Fake/Mock/Stub/Simulated para PostgreSQL

## Trocar agora por PostgreSQL
- Core/Admin, Journey, Flow, Studio, Clientes, Produtos, Estoque, Pedidos, Faturas, Títulos, Outbox, Project, Forms e Reports.
- Classes críticas mapeadas: `InMemoryFlowServices`, `InMemoryFlowCoreServices`, `InMemoryStudioServices`, `InMemoryBiProjectService`, `InMemoryBillingService`, `InMemoryConnectService`, `InMemoryMobileFieldService` e serviços operacionais com listas em memória.

## Manter fake/sandbox por enquanto
- WhatsApp real, e-mail real, Telegram real, SEFAZ real, banco/Open Finance real, Google Maps/Waze real e IA externa real.
- Providers mantidos como sandbox/log: boleto fake, documento fiscal fake, e-mail fake, WhatsApp fake, Telegram fake, webhook fake e IA fake governada.

## Próximo passo
Implementar repositories Dapper por interface, remover registros conflitantes de DI por módulo e manter providers externos fake atrás de contratos explícitos.
