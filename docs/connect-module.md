# Integra Connect

Connect centraliza templates, renderização segura, mensagens fake/log, conversas, webhooks fake/log e indicadores operacionais.

## Templates

Templates usam variáveis simples com `{{nome_variavel}}`. O renderer não executa código, não usa `eval`, sanitiza marcações básicas e retorna warnings quando uma variável não foi fornecida.

## Providers fake/log

- `FAKE-EMAIL`
- `FAKE-WHATSAPP`
- `FAKE-TELEGRAM`
- `FAKE-CONNECT`

Use `IntegraRP:FakeProviders:ForceError=true` para simular erro.
