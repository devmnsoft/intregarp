using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/activities")]
public sealed class ActivitiesController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(DemoData.Activities);
}

internal static class DemoData
{
    public static readonly object[] Activities =
    [
        new { codigo="cadastrar-cliente", titulo="Cadastrar cliente", descricao="Criar cliente demo ou real", modulo="Comercial", rotaWeb="/customers", rotaApi="/api/customers", status="funcional", permissao="customers.create" },
        new { codigo="cadastrar-produto", titulo="Cadastrar produto", descricao="Criar produto comercial", modulo="Estoque", rotaWeb="/products", rotaApi="/api/products", status="funcional", permissao="products.create" },
        new { codigo="entrada-estoque", titulo="Registrar entrada de estoque", descricao="Atualizar saldo real", modulo="Estoque", rotaWeb="/inventory", rotaApi="/api/inventory/entries", status="funcional", permissao="inventory.entry" },
        new { codigo="criar-pedido", titulo="Criar pedido", descricao="Gerar pedido com itens", modulo="Pedidos", rotaWeb="/orders", rotaApi="/api/orders", status="funcional", permissao="orders.create" },
        new { codigo="minhas-tarefas", titulo="Ver minhas tarefas", descricao="Listar tarefas pendentes", modulo="Tarefas", rotaWeb="/tasks/my", rotaApi="/api/tasks/my", status="funcional", permissao="tasks.view" },
        new { codigo="gerar-fatura", titulo="Gerar fatura", descricao="Faturar pedido", modulo="Financeiro", rotaWeb="/billing/invoices", rotaApi="/api/billing/invoices", status="funcional", permissao="billing.create" },
        new { codigo="processar-outbox", titulo="Processar outbox", descricao="Processar pendências Connect", modulo="Connect", rotaWeb="/connect/outbox", rotaApi="/api/connect/outbox/process", status="funcional", permissao="outbox.process" },
        new { codigo="ver-dashboard", titulo="Ver dashboard", descricao="Acompanhar KPIs reais", modulo="Dashboard", rotaWeb="/dashboard", rotaApi="/api/dashboard", status="funcional", permissao="dashboard.view" },
        new { codigo="instalar-template", titulo="Instalar template", descricao="Instalar pacote operacional", modulo="Templates", rotaWeb="/templates", rotaApi="/api/operational-templates", status="funcional", permissao="templates.install" },
        new { codigo="ver-jornada", titulo="Ver jornada", descricao="Continuar onboarding", modulo="Jornada", rotaWeb="/journey/what-to-do-now", rotaApi="/api/journey/what-to-do-now", status="funcional", permissao="journey.view" }
    ];

    public static readonly object[] Steps =
    [
        new { stepCode="cliente", titulo="Cliente", status="ok", dados="Cliente Demo Atacado", rotaWeb="/customers", proximaAcao="Ver produto" },
        new { stepCode="produto", titulo="Produto", status="ok", dados="Produto Demo A", rotaWeb="/products", proximaAcao="Ver estoque" },
        new { stepCode="estoque", titulo="Estoque", status="ok", dados="Saldo carregado", rotaWeb="/inventory", proximaAcao="Criar pedido" },
        new { stepCode="pedido", titulo="Pedido", status="ok", dados="PED-DEMO-004", rotaWeb="/orders", proximaAcao="Confirmar" },
        new { stepCode="tarefa", titulo="Tarefa", status="ok", dados="Separação e faturamento", rotaWeb="/tasks/my", proximaAcao="Faturar" },
        new { stepCode="faturamento", titulo="Faturamento", status="ok", dados="FAT-DEMO-001", rotaWeb="/billing/invoices", proximaAcao="Gerar título" },
        new { stepCode="titulo", titulo="Título", status="ok", dados="TIT-DEMO-001", rotaWeb="/billing/titles", proximaAcao="Boleto fake" },
        new { stepCode="outbox", titulo="Outbox", status="ok", dados="Evento pendente/processado/erro", rotaWeb="/connect/outbox", proximaAcao="Dashboard" },
        new { stepCode="dashboard", titulo="Dashboard", status="ok", dados="KPIs reais", rotaWeb="/dashboard", proximaAcao="Jornada" },
        new { stepCode="jornada", titulo="Jornada", status="ok", dados="Acompanhar dashboard", rotaWeb="/journey/what-to-do-now", proximaAcao="Operar" }
    ];

    public static object Dashboard => new { clientesAtivos=3, produtosAtivos=3, estoqueCritico=1, pedidosEmAberto=3, pedidosConfirmados=1, tarefasPendentes=3, tarefasAtrasadas=1, faturasEmitidas=1, titulosEmAberto=1, titulosVencidos=1, outboxPendente=1, jornadaProgresso=80, proximaAcao="Processar outbox" };
    public static object WhatToDo => new { codigo="processar-outbox", titulo="Processar outbox", detalhe="Há evento pendente carregado pela seed v1.9.", rotaWeb="/connect/outbox" };
}
