# Providers fake/log

A Sprint 6 não integra provedores reais. Todos os provedores apenas registram logs e retornam respostas estruturadas de demonstração.

## Boleto

`FakeBoletoProvider` gera link, linha digitável, código de barras e nosso número com prefixo `FAKE-BOLETO`.

## Fiscal

Referências fiscais usam prefixo `FAKE-NFE` e não chamam SEFAZ.

## Mensagens

Envios retornam logs com prefixos `FAKE-EMAIL`, `FAKE-WHATSAPP` e `FAKE-TELEGRAM`.
