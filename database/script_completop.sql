-- Produto: IntegraRP
-- Versão: v1.27
-- PostgreSQL: 16
-- Schema: integrarp
-- checksum: 43238251e5a5250bcfbf881597201d7c2aed5f11a70f1a124d476f62f4b622b5
-- migrations: 33
-- data de geração: 2026-07-23T16:36:29Z
-- instrução de execução: psql "$INTEGRARP_CONNECTION_STRING" -v ON_ERROR_STOP=1 -f database/script_completop.sql
-- aviso: este script não cria senha fixa; credenciais iniciais devem ser provisionadas por configuração segura.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

BEGIN;

-- >>> 0001_initial_integrarp.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (
    migration_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    script_name varchar(260) UNIQUE NOT NULL,
    checksum_sha256 varchar(128) NOT NULL,
    executed_at timestamptz NOT NULL DEFAULT now(),
    duration_ms bigint NOT NULL DEFAULT 0,
    success boolean NOT NULL DEFAULT true,
    error_message text NULL,
    executed_by varchar(160) NULL
);

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.atualizado_em = now();
  RETURN NEW;
END;
$$;

CREATE TABLE IF NOT EXISTS integrarp.tenant (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_tenant_tenant_id ON integrarp.tenant(tenant_id);
CREATE INDEX IF NOT EXISTS ix_tenant_status ON integrarp.tenant(status);
CREATE INDEX IF NOT EXISTS ix_tenant_criado_em ON integrarp.tenant(criado_em);
CREATE INDEX IF NOT EXISTS ix_tenant_setor_id ON integrarp.tenant(setor_id);
CREATE INDEX IF NOT EXISTS ix_tenant_responsavel_usuario_id ON integrarp.tenant(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tenant_prioridade ON integrarp.tenant(prioridade);
CREATE INDEX IF NOT EXISTS ix_tenant_sprint_id ON integrarp.tenant(sprint_id);
DROP TRIGGER IF EXISTS trg_tenant_atualizado_em ON integrarp.tenant;
CREATE TRIGGER trg_tenant_atualizado_em
BEFORE UPDATE ON integrarp.tenant
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.setor (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.setor ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_setor_tenant_id ON integrarp.setor(tenant_id);
CREATE INDEX IF NOT EXISTS ix_setor_status ON integrarp.setor(status);
CREATE INDEX IF NOT EXISTS ix_setor_criado_em ON integrarp.setor(criado_em);
CREATE INDEX IF NOT EXISTS ix_setor_setor_id ON integrarp.setor(setor_id);
CREATE INDEX IF NOT EXISTS ix_setor_responsavel_usuario_id ON integrarp.setor(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_setor_prioridade ON integrarp.setor(prioridade);
CREATE INDEX IF NOT EXISTS ix_setor_sprint_id ON integrarp.setor(sprint_id);
DROP TRIGGER IF EXISTS trg_setor_atualizado_em ON integrarp.setor;
CREATE TRIGGER trg_setor_atualizado_em
BEFORE UPDATE ON integrarp.setor
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.usuario (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_usuario_tenant_id ON integrarp.usuario(tenant_id);
CREATE INDEX IF NOT EXISTS ix_usuario_status ON integrarp.usuario(status);
CREATE INDEX IF NOT EXISTS ix_usuario_criado_em ON integrarp.usuario(criado_em);
CREATE INDEX IF NOT EXISTS ix_usuario_setor_id ON integrarp.usuario(setor_id);
CREATE INDEX IF NOT EXISTS ix_usuario_responsavel_usuario_id ON integrarp.usuario(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_usuario_prioridade ON integrarp.usuario(prioridade);
CREATE INDEX IF NOT EXISTS ix_usuario_sprint_id ON integrarp.usuario(sprint_id);
DROP TRIGGER IF EXISTS trg_usuario_atualizado_em ON integrarp.usuario;
CREATE TRIGGER trg_usuario_atualizado_em
BEFORE UPDATE ON integrarp.usuario
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.cliente (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.cliente ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_cliente_tenant_id ON integrarp.cliente(tenant_id);
CREATE INDEX IF NOT EXISTS ix_cliente_status ON integrarp.cliente(status);
CREATE INDEX IF NOT EXISTS ix_cliente_criado_em ON integrarp.cliente(criado_em);
CREATE INDEX IF NOT EXISTS ix_cliente_setor_id ON integrarp.cliente(setor_id);
CREATE INDEX IF NOT EXISTS ix_cliente_responsavel_usuario_id ON integrarp.cliente(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_cliente_prioridade ON integrarp.cliente(prioridade);
CREATE INDEX IF NOT EXISTS ix_cliente_sprint_id ON integrarp.cliente(sprint_id);
DROP TRIGGER IF EXISTS trg_cliente_atualizado_em ON integrarp.cliente;
CREATE TRIGGER trg_cliente_atualizado_em
BEFORE UPDATE ON integrarp.cliente
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.produto (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_produto_tenant_id ON integrarp.produto(tenant_id);
CREATE INDEX IF NOT EXISTS ix_produto_status ON integrarp.produto(status);
CREATE INDEX IF NOT EXISTS ix_produto_criado_em ON integrarp.produto(criado_em);
CREATE INDEX IF NOT EXISTS ix_produto_setor_id ON integrarp.produto(setor_id);
CREATE INDEX IF NOT EXISTS ix_produto_responsavel_usuario_id ON integrarp.produto(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_produto_prioridade ON integrarp.produto(prioridade);
CREATE INDEX IF NOT EXISTS ix_produto_sprint_id ON integrarp.produto(sprint_id);
DROP TRIGGER IF EXISTS trg_produto_atualizado_em ON integrarp.produto;
CREATE TRIGGER trg_produto_atualizado_em
BEFORE UPDATE ON integrarp.produto
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.pedido (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_pedido_tenant_id ON integrarp.pedido(tenant_id);
CREATE INDEX IF NOT EXISTS ix_pedido_status ON integrarp.pedido(status);
CREATE INDEX IF NOT EXISTS ix_pedido_criado_em ON integrarp.pedido(criado_em);
CREATE INDEX IF NOT EXISTS ix_pedido_setor_id ON integrarp.pedido(setor_id);
CREATE INDEX IF NOT EXISTS ix_pedido_responsavel_usuario_id ON integrarp.pedido(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_pedido_prioridade ON integrarp.pedido(prioridade);
CREATE INDEX IF NOT EXISTS ix_pedido_sprint_id ON integrarp.pedido(sprint_id);
DROP TRIGGER IF EXISTS trg_pedido_atualizado_em ON integrarp.pedido;
CREATE TRIGGER trg_pedido_atualizado_em
BEFORE UPDATE ON integrarp.pedido
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.estoque_lote (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.estoque_lote ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_estoque_lote_tenant_id ON integrarp.estoque_lote(tenant_id);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_status ON integrarp.estoque_lote(status);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_criado_em ON integrarp.estoque_lote(criado_em);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_setor_id ON integrarp.estoque_lote(setor_id);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_responsavel_usuario_id ON integrarp.estoque_lote(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_prioridade ON integrarp.estoque_lote(prioridade);
CREATE INDEX IF NOT EXISTS ix_estoque_lote_sprint_id ON integrarp.estoque_lote(sprint_id);
DROP TRIGGER IF EXISTS trg_estoque_lote_atualizado_em ON integrarp.estoque_lote;
CREATE TRIGGER trg_estoque_lote_atualizado_em
BEFORE UPDATE ON integrarp.estoque_lote
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.titulo_financeiro ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_tenant_id ON integrarp.titulo_financeiro(tenant_id);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_status ON integrarp.titulo_financeiro(status);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_criado_em ON integrarp.titulo_financeiro(criado_em);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_setor_id ON integrarp.titulo_financeiro(setor_id);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_responsavel_usuario_id ON integrarp.titulo_financeiro(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_prioridade ON integrarp.titulo_financeiro(prioridade);
CREATE INDEX IF NOT EXISTS ix_titulo_financeiro_sprint_id ON integrarp.titulo_financeiro(sprint_id);
DROP TRIGGER IF EXISTS trg_titulo_financeiro_atualizado_em ON integrarp.titulo_financeiro;
CREATE TRIGGER trg_titulo_financeiro_atualizado_em
BEFORE UPDATE ON integrarp.titulo_financeiro
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_definicao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_definicao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_definicao_tenant_id ON integrarp.processo_definicao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_status ON integrarp.processo_definicao(status);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_criado_em ON integrarp.processo_definicao(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_setor_id ON integrarp.processo_definicao(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_responsavel_usuario_id ON integrarp.processo_definicao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_prioridade ON integrarp.processo_definicao(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_definicao_sprint_id ON integrarp.processo_definicao(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_definicao_atualizado_em ON integrarp.processo_definicao;
CREATE TRIGGER trg_processo_definicao_atualizado_em
BEFORE UPDATE ON integrarp.processo_definicao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_versao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_versao_tenant_id ON integrarp.processo_versao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_versao_status ON integrarp.processo_versao(status);
CREATE INDEX IF NOT EXISTS ix_processo_versao_criado_em ON integrarp.processo_versao(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_versao_setor_id ON integrarp.processo_versao(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_versao_responsavel_usuario_id ON integrarp.processo_versao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_versao_prioridade ON integrarp.processo_versao(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_versao_sprint_id ON integrarp.processo_versao(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_versao_atualizado_em ON integrarp.processo_versao;
CREATE TRIGGER trg_processo_versao_atualizado_em
BEFORE UPDATE ON integrarp.processo_versao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_elemento (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_elemento_tenant_id ON integrarp.processo_elemento(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_status ON integrarp.processo_elemento(status);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_criado_em ON integrarp.processo_elemento(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_setor_id ON integrarp.processo_elemento(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_responsavel_usuario_id ON integrarp.processo_elemento(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_prioridade ON integrarp.processo_elemento(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_sprint_id ON integrarp.processo_elemento(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_elemento_atualizado_em ON integrarp.processo_elemento;
CREATE TRIGGER trg_processo_elemento_atualizado_em
BEFORE UPDATE ON integrarp.processo_elemento
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_transicao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_transicao_tenant_id ON integrarp.processo_transicao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_status ON integrarp.processo_transicao(status);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_criado_em ON integrarp.processo_transicao(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_setor_id ON integrarp.processo_transicao(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_responsavel_usuario_id ON integrarp.processo_transicao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_prioridade ON integrarp.processo_transicao(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_sprint_id ON integrarp.processo_transicao(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_transicao_atualizado_em ON integrarp.processo_transicao;
CREATE TRIGGER trg_processo_transicao_atualizado_em
BEFORE UPDATE ON integrarp.processo_transicao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_instancia (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_instancia ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_instancia_tenant_id ON integrarp.processo_instancia(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_status ON integrarp.processo_instancia(status);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_criado_em ON integrarp.processo_instancia(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_setor_id ON integrarp.processo_instancia(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_responsavel_usuario_id ON integrarp.processo_instancia(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_prioridade ON integrarp.processo_instancia(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_sprint_id ON integrarp.processo_instancia(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_instancia_atualizado_em ON integrarp.processo_instancia;
CREATE TRIGGER trg_processo_instancia_atualizado_em
BEFORE UPDATE ON integrarp.processo_instancia
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_variavel (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_variavel ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_variavel_tenant_id ON integrarp.processo_variavel(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_status ON integrarp.processo_variavel(status);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_criado_em ON integrarp.processo_variavel(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_setor_id ON integrarp.processo_variavel(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_responsavel_usuario_id ON integrarp.processo_variavel(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_prioridade ON integrarp.processo_variavel(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_variavel_sprint_id ON integrarp.processo_variavel(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_variavel_atualizado_em ON integrarp.processo_variavel;
CREATE TRIGGER trg_processo_variavel_atualizado_em
BEFORE UPDATE ON integrarp.processo_variavel
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.tarefa (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.tarefa ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_id ON integrarp.tarefa(tenant_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_status ON integrarp.tarefa(status);
CREATE INDEX IF NOT EXISTS ix_tarefa_criado_em ON integrarp.tarefa(criado_em);
CREATE INDEX IF NOT EXISTS ix_tarefa_setor_id ON integrarp.tarefa(setor_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_responsavel_usuario_id ON integrarp.tarefa(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_prioridade ON integrarp.tarefa(prioridade);
CREATE INDEX IF NOT EXISTS ix_tarefa_sprint_id ON integrarp.tarefa(sprint_id);
DROP TRIGGER IF EXISTS trg_tarefa_atualizado_em ON integrarp.tarefa;
CREATE TRIGGER trg_tarefa_atualizado_em
BEFORE UPDATE ON integrarp.tarefa
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.tarefa_comentario ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_tenant_id ON integrarp.tarefa_comentario(tenant_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_status ON integrarp.tarefa_comentario(status);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_criado_em ON integrarp.tarefa_comentario(criado_em);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_setor_id ON integrarp.tarefa_comentario(setor_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_responsavel_usuario_id ON integrarp.tarefa_comentario(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_prioridade ON integrarp.tarefa_comentario(prioridade);
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_sprint_id ON integrarp.tarefa_comentario(sprint_id);
DROP TRIGGER IF EXISTS trg_tarefa_comentario_atualizado_em ON integrarp.tarefa_comentario;
CREATE TRIGGER trg_tarefa_comentario_atualizado_em
BEFORE UPDATE ON integrarp.tarefa_comentario
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.tarefa_anexo (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.tarefa_anexo ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_tenant_id ON integrarp.tarefa_anexo(tenant_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_status ON integrarp.tarefa_anexo(status);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_criado_em ON integrarp.tarefa_anexo(criado_em);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_setor_id ON integrarp.tarefa_anexo(setor_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_responsavel_usuario_id ON integrarp.tarefa_anexo(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_prioridade ON integrarp.tarefa_anexo(prioridade);
CREATE INDEX IF NOT EXISTS ix_tarefa_anexo_sprint_id ON integrarp.tarefa_anexo(sprint_id);
DROP TRIGGER IF EXISTS trg_tarefa_anexo_atualizado_em ON integrarp.tarefa_anexo;
CREATE TRIGGER trg_tarefa_anexo_atualizado_em
BEFORE UPDATE ON integrarp.tarefa_anexo
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_sla_politica (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_sla_politica ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_tenant_id ON integrarp.processo_sla_politica(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_status ON integrarp.processo_sla_politica(status);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_criado_em ON integrarp.processo_sla_politica(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_setor_id ON integrarp.processo_sla_politica(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_responsavel_usuario_id ON integrarp.processo_sla_politica(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_prioridade ON integrarp.processo_sla_politica(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_sla_politica_sprint_id ON integrarp.processo_sla_politica(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_sla_politica_atualizado_em ON integrarp.processo_sla_politica;
CREATE TRIGGER trg_processo_sla_politica_atualizado_em
BEFORE UPDATE ON integrarp.processo_sla_politica
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_evento_vinculo (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_evento_vinculo ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_tenant_id ON integrarp.processo_evento_vinculo(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_status ON integrarp.processo_evento_vinculo(status);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_criado_em ON integrarp.processo_evento_vinculo(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_setor_id ON integrarp.processo_evento_vinculo(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_responsavel_usuario_id ON integrarp.processo_evento_vinculo(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_prioridade ON integrarp.processo_evento_vinculo(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_evento_vinculo_sprint_id ON integrarp.processo_evento_vinculo(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_evento_vinculo_atualizado_em ON integrarp.processo_evento_vinculo;
CREATE TRIGGER trg_processo_evento_vinculo_atualizado_em
BEFORE UPDATE ON integrarp.processo_evento_vinculo
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.processo_auditoria_evento (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.processo_auditoria_evento ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_tenant_id ON integrarp.processo_auditoria_evento(tenant_id);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_status ON integrarp.processo_auditoria_evento(status);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_criado_em ON integrarp.processo_auditoria_evento(criado_em);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_setor_id ON integrarp.processo_auditoria_evento(setor_id);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_responsavel_usuario_id ON integrarp.processo_auditoria_evento(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_prioridade ON integrarp.processo_auditoria_evento(prioridade);
CREATE INDEX IF NOT EXISTS ix_processo_auditoria_evento_sprint_id ON integrarp.processo_auditoria_evento(sprint_id);
DROP TRIGGER IF EXISTS trg_processo_auditoria_evento_atualizado_em ON integrarp.processo_auditoria_evento;
CREATE TRIGGER trg_processo_auditoria_evento_atualizado_em
BEFORE UPDATE ON integrarp.processo_auditoria_evento
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_dinamico (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_dinamico ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_tenant_id ON integrarp.modulo_dinamico(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_status ON integrarp.modulo_dinamico(status);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_criado_em ON integrarp.modulo_dinamico(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_setor_id ON integrarp.modulo_dinamico(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_responsavel_usuario_id ON integrarp.modulo_dinamico(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_prioridade ON integrarp.modulo_dinamico(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_dinamico_sprint_id ON integrarp.modulo_dinamico(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_dinamico_atualizado_em ON integrarp.modulo_dinamico;
CREATE TRIGGER trg_modulo_dinamico_atualizado_em
BEFORE UPDATE ON integrarp.modulo_dinamico
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_entidade (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_entidade ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_tenant_id ON integrarp.modulo_entidade(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_status ON integrarp.modulo_entidade(status);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_criado_em ON integrarp.modulo_entidade(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_setor_id ON integrarp.modulo_entidade(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_responsavel_usuario_id ON integrarp.modulo_entidade(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_prioridade ON integrarp.modulo_entidade(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_entidade_sprint_id ON integrarp.modulo_entidade(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_entidade_atualizado_em ON integrarp.modulo_entidade;
CREATE TRIGGER trg_modulo_entidade_atualizado_em
BEFORE UPDATE ON integrarp.modulo_entidade
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_campo (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_campo ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_campo_tenant_id ON integrarp.modulo_campo(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_status ON integrarp.modulo_campo(status);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_criado_em ON integrarp.modulo_campo(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_setor_id ON integrarp.modulo_campo(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_responsavel_usuario_id ON integrarp.modulo_campo(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_prioridade ON integrarp.modulo_campo(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_campo_sprint_id ON integrarp.modulo_campo(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_campo_atualizado_em ON integrarp.modulo_campo;
CREATE TRIGGER trg_modulo_campo_atualizado_em
BEFORE UPDATE ON integrarp.modulo_campo
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_acao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_acao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_acao_tenant_id ON integrarp.modulo_acao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_status ON integrarp.modulo_acao(status);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_criado_em ON integrarp.modulo_acao(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_setor_id ON integrarp.modulo_acao(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_responsavel_usuario_id ON integrarp.modulo_acao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_prioridade ON integrarp.modulo_acao(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_acao_sprint_id ON integrarp.modulo_acao(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_acao_atualizado_em ON integrarp.modulo_acao;
CREATE TRIGGER trg_modulo_acao_atualizado_em
BEFORE UPDATE ON integrarp.modulo_acao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_registro_tenant_id ON integrarp.modulo_registro(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_status ON integrarp.modulo_registro(status);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_criado_em ON integrarp.modulo_registro(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_setor_id ON integrarp.modulo_registro(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_responsavel_usuario_id ON integrarp.modulo_registro(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_prioridade ON integrarp.modulo_registro(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_sprint_id ON integrarp.modulo_registro(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_registro_atualizado_em ON integrarp.modulo_registro;
CREATE TRIGGER trg_modulo_registro_atualizado_em
BEFORE UPDATE ON integrarp.modulo_registro
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_valor (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_tenant_id ON integrarp.modulo_registro_valor(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_status ON integrarp.modulo_registro_valor(status);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_criado_em ON integrarp.modulo_registro_valor(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_setor_id ON integrarp.modulo_registro_valor(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_responsavel_usuario_id ON integrarp.modulo_registro_valor(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_prioridade ON integrarp.modulo_registro_valor(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_sprint_id ON integrarp.modulo_registro_valor(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_registro_valor_atualizado_em ON integrarp.modulo_registro_valor;
CREATE TRIGGER trg_modulo_registro_valor_atualizado_em
BEFORE UPDATE ON integrarp.modulo_registro_valor
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_historico (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_registro_historico ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_tenant_id ON integrarp.modulo_registro_historico(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_status ON integrarp.modulo_registro_historico(status);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_criado_em ON integrarp.modulo_registro_historico(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_setor_id ON integrarp.modulo_registro_historico(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_responsavel_usuario_id ON integrarp.modulo_registro_historico(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_prioridade ON integrarp.modulo_registro_historico(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_sprint_id ON integrarp.modulo_registro_historico(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_registro_historico_atualizado_em ON integrarp.modulo_registro_historico;
CREATE TRIGGER trg_modulo_registro_historico_atualizado_em
BEFORE UPDATE ON integrarp.modulo_registro_historico
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_relacionamento (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_relacionamento ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_tenant_id ON integrarp.modulo_relacionamento(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_status ON integrarp.modulo_relacionamento(status);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_criado_em ON integrarp.modulo_relacionamento(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_setor_id ON integrarp.modulo_relacionamento(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_responsavel_usuario_id ON integrarp.modulo_relacionamento(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_prioridade ON integrarp.modulo_relacionamento(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_sprint_id ON integrarp.modulo_relacionamento(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_relacionamento_atualizado_em ON integrarp.modulo_relacionamento;
CREATE TRIGGER trg_modulo_relacionamento_atualizado_em
BEFORE UPDATE ON integrarp.modulo_relacionamento
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_permissao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_permissao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_tenant_id ON integrarp.modulo_permissao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_status ON integrarp.modulo_permissao(status);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_criado_em ON integrarp.modulo_permissao(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_setor_id ON integrarp.modulo_permissao(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_responsavel_usuario_id ON integrarp.modulo_permissao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_prioridade ON integrarp.modulo_permissao(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_sprint_id ON integrarp.modulo_permissao(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_permissao_atualizado_em ON integrarp.modulo_permissao;
CREATE TRIGGER trg_modulo_permissao_atualizado_em
BEFORE UPDATE ON integrarp.modulo_permissao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_menu (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_menu ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_menu_tenant_id ON integrarp.modulo_menu(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_status ON integrarp.modulo_menu(status);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_criado_em ON integrarp.modulo_menu(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_setor_id ON integrarp.modulo_menu(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_responsavel_usuario_id ON integrarp.modulo_menu(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_prioridade ON integrarp.modulo_menu(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_sprint_id ON integrarp.modulo_menu(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_menu_atualizado_em ON integrarp.modulo_menu;
CREATE TRIGGER trg_modulo_menu_atualizado_em
BEFORE UPDATE ON integrarp.modulo_menu
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_kpi (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_kpi ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_tenant_id ON integrarp.modulo_kpi(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_status ON integrarp.modulo_kpi(status);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_criado_em ON integrarp.modulo_kpi(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_setor_id ON integrarp.modulo_kpi(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_responsavel_usuario_id ON integrarp.modulo_kpi(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_prioridade ON integrarp.modulo_kpi(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_sprint_id ON integrarp.modulo_kpi(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_kpi_atualizado_em ON integrarp.modulo_kpi;
CREATE TRIGGER trg_modulo_kpi_atualizado_em
BEFORE UPDATE ON integrarp.modulo_kpi
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_bpmn_vinculo (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_bpmn_vinculo ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_tenant_id ON integrarp.modulo_bpmn_vinculo(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_status ON integrarp.modulo_bpmn_vinculo(status);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_criado_em ON integrarp.modulo_bpmn_vinculo(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_setor_id ON integrarp.modulo_bpmn_vinculo(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_responsavel_usuario_id ON integrarp.modulo_bpmn_vinculo(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_prioridade ON integrarp.modulo_bpmn_vinculo(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_sprint_id ON integrarp.modulo_bpmn_vinculo(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_bpmn_vinculo_atualizado_em ON integrarp.modulo_bpmn_vinculo;
CREATE TRIGGER trg_modulo_bpmn_vinculo_atualizado_em
BEFORE UPDATE ON integrarp.modulo_bpmn_vinculo
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.modulo_catalogo_semantico (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.modulo_catalogo_semantico ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_tenant_id ON integrarp.modulo_catalogo_semantico(tenant_id);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_status ON integrarp.modulo_catalogo_semantico(status);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_criado_em ON integrarp.modulo_catalogo_semantico(criado_em);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_setor_id ON integrarp.modulo_catalogo_semantico(setor_id);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_responsavel_usuario_id ON integrarp.modulo_catalogo_semantico(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_prioridade ON integrarp.modulo_catalogo_semantico(prioridade);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_sprint_id ON integrarp.modulo_catalogo_semantico(sprint_id);
DROP TRIGGER IF EXISTS trg_modulo_catalogo_semantico_atualizado_em ON integrarp.modulo_catalogo_semantico;
CREATE TRIGGER trg_modulo_catalogo_semantico_atualizado_em
BEFORE UPDATE ON integrarp.modulo_catalogo_semantico
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_agente (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_agente ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_agente_tenant_id ON integrarp.ai_agente(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_agente_status ON integrarp.ai_agente(status);
CREATE INDEX IF NOT EXISTS ix_ai_agente_criado_em ON integrarp.ai_agente(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_agente_setor_id ON integrarp.ai_agente(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_agente_responsavel_usuario_id ON integrarp.ai_agente(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_agente_prioridade ON integrarp.ai_agente(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_agente_sprint_id ON integrarp.ai_agente(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_agente_atualizado_em ON integrarp.ai_agente;
CREATE TRIGGER trg_ai_agente_atualizado_em
BEFORE UPDATE ON integrarp.ai_agente
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_intencao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_intencao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_intencao_tenant_id ON integrarp.ai_intencao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_status ON integrarp.ai_intencao(status);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_criado_em ON integrarp.ai_intencao(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_setor_id ON integrarp.ai_intencao(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_responsavel_usuario_id ON integrarp.ai_intencao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_prioridade ON integrarp.ai_intencao(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_intencao_sprint_id ON integrarp.ai_intencao(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_intencao_atualizado_em ON integrarp.ai_intencao;
CREATE TRIGGER trg_ai_intencao_atualizado_em
BEFORE UPDATE ON integrarp.ai_intencao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_tenant_id ON integrarp.ai_ferramenta(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_status ON integrarp.ai_ferramenta(status);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_criado_em ON integrarp.ai_ferramenta(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_setor_id ON integrarp.ai_ferramenta(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_responsavel_usuario_id ON integrarp.ai_ferramenta(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_prioridade ON integrarp.ai_ferramenta(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_sprint_id ON integrarp.ai_ferramenta(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_ferramenta_atualizado_em ON integrarp.ai_ferramenta;
CREATE TRIGGER trg_ai_ferramenta_atualizado_em
BEFORE UPDATE ON integrarp.ai_ferramenta
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta_permissao (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_ferramenta_permissao ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_tenant_id ON integrarp.ai_ferramenta_permissao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_status ON integrarp.ai_ferramenta_permissao(status);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_criado_em ON integrarp.ai_ferramenta_permissao(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_setor_id ON integrarp.ai_ferramenta_permissao(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_responsavel_usuario_id ON integrarp.ai_ferramenta_permissao(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_prioridade ON integrarp.ai_ferramenta_permissao(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_sprint_id ON integrarp.ai_ferramenta_permissao(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_ferramenta_permissao_atualizado_em ON integrarp.ai_ferramenta_permissao;
CREATE TRIGGER trg_ai_ferramenta_permissao_atualizado_em
BEFORE UPDATE ON integrarp.ai_ferramenta_permissao
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_conversa (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_conversa ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_conversa_tenant_id ON integrarp.ai_conversa(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_status ON integrarp.ai_conversa(status);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_criado_em ON integrarp.ai_conversa(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_setor_id ON integrarp.ai_conversa(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_responsavel_usuario_id ON integrarp.ai_conversa(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_prioridade ON integrarp.ai_conversa(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_conversa_sprint_id ON integrarp.ai_conversa(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_conversa_atualizado_em ON integrarp.ai_conversa;
CREATE TRIGGER trg_ai_conversa_atualizado_em
BEFORE UPDATE ON integrarp.ai_conversa
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_mensagem (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_tenant_id ON integrarp.ai_mensagem(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_status ON integrarp.ai_mensagem(status);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_criado_em ON integrarp.ai_mensagem(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_setor_id ON integrarp.ai_mensagem(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_responsavel_usuario_id ON integrarp.ai_mensagem(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_prioridade ON integrarp.ai_mensagem(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_mensagem_sprint_id ON integrarp.ai_mensagem(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_mensagem_atualizado_em ON integrarp.ai_mensagem;
CREATE TRIGGER trg_ai_mensagem_atualizado_em
BEFORE UPDATE ON integrarp.ai_mensagem
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_auditoria (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_tenant_id ON integrarp.ai_auditoria(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_status ON integrarp.ai_auditoria(status);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_criado_em ON integrarp.ai_auditoria(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_setor_id ON integrarp.ai_auditoria(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_responsavel_usuario_id ON integrarp.ai_auditoria(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_prioridade ON integrarp.ai_auditoria(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_auditoria_sprint_id ON integrarp.ai_auditoria(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_auditoria_atualizado_em ON integrarp.ai_auditoria;
CREATE TRIGGER trg_ai_auditoria_atualizado_em
BEFORE UPDATE ON integrarp.ai_auditoria
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.ai_escalonamento_humano (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.ai_escalonamento_humano ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_tenant_id ON integrarp.ai_escalonamento_humano(tenant_id);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_status ON integrarp.ai_escalonamento_humano(status);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_criado_em ON integrarp.ai_escalonamento_humano(criado_em);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_setor_id ON integrarp.ai_escalonamento_humano(setor_id);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_responsavel_usuario_id ON integrarp.ai_escalonamento_humano(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_prioridade ON integrarp.ai_escalonamento_humano(prioridade);
CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_sprint_id ON integrarp.ai_escalonamento_humano(sprint_id);
DROP TRIGGER IF EXISTS trg_ai_escalonamento_humano_atualizado_em ON integrarp.ai_escalonamento_humano;
CREATE TRIGGER trg_ai_escalonamento_humano_atualizado_em
BEFORE UPDATE ON integrarp.ai_escalonamento_humano
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.evento_negocio (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.evento_negocio ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_evento_negocio_tenant_id ON integrarp.evento_negocio(tenant_id);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_status ON integrarp.evento_negocio(status);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_criado_em ON integrarp.evento_negocio(criado_em);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_setor_id ON integrarp.evento_negocio(setor_id);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_responsavel_usuario_id ON integrarp.evento_negocio(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_prioridade ON integrarp.evento_negocio(prioridade);
CREATE INDEX IF NOT EXISTS ix_evento_negocio_sprint_id ON integrarp.evento_negocio(sprint_id);
DROP TRIGGER IF EXISTS trg_evento_negocio_atualizado_em ON integrarp.evento_negocio;
CREATE TRIGGER trg_evento_negocio_atualizado_em
BEFORE UPDATE ON integrarp.evento_negocio
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_board (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_board ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_tenant_id ON integrarp.projeto_central_board(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_status ON integrarp.projeto_central_board(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_criado_em ON integrarp.projeto_central_board(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_setor_id ON integrarp.projeto_central_board(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_responsavel_usuario_id ON integrarp.projeto_central_board(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_prioridade ON integrarp.projeto_central_board(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_sprint_id ON integrarp.projeto_central_board(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_board_atualizado_em ON integrarp.projeto_central_board;
CREATE TRIGGER trg_projeto_central_board_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_board
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_sprint (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_sprint ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_tenant_id ON integrarp.projeto_central_sprint(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_status ON integrarp.projeto_central_sprint(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_criado_em ON integrarp.projeto_central_sprint(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_setor_id ON integrarp.projeto_central_sprint(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_responsavel_usuario_id ON integrarp.projeto_central_sprint(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_prioridade ON integrarp.projeto_central_sprint(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_sprint_id ON integrarp.projeto_central_sprint(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_sprint_atualizado_em ON integrarp.projeto_central_sprint;
CREATE TRIGGER trg_projeto_central_sprint_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_sprint
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_coluna (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_coluna ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_tenant_id ON integrarp.projeto_central_coluna(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_status ON integrarp.projeto_central_coluna(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_criado_em ON integrarp.projeto_central_coluna(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_setor_id ON integrarp.projeto_central_coluna(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_responsavel_usuario_id ON integrarp.projeto_central_coluna(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_prioridade ON integrarp.projeto_central_coluna(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_sprint_id ON integrarp.projeto_central_coluna(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_coluna_atualizado_em ON integrarp.projeto_central_coluna;
CREATE TRIGGER trg_projeto_central_coluna_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_coluna
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_item ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_tenant_id ON integrarp.projeto_central_item(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_status ON integrarp.projeto_central_item(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_criado_em ON integrarp.projeto_central_item(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_setor_id ON integrarp.projeto_central_item(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_responsavel_usuario_id ON integrarp.projeto_central_item(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_prioridade ON integrarp.projeto_central_item(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_sprint_id ON integrarp.projeto_central_item(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_item_atualizado_em ON integrarp.projeto_central_item;
CREATE TRIGGER trg_projeto_central_item_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_item
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item_comentario (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_item_comentario ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_tenant_id ON integrarp.projeto_central_item_comentario(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_status ON integrarp.projeto_central_item_comentario(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_criado_em ON integrarp.projeto_central_item_comentario(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_setor_id ON integrarp.projeto_central_item_comentario(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_responsavel_usuario_id ON integrarp.projeto_central_item_comentario(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_prioridade ON integrarp.projeto_central_item_comentario(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_sprint_id ON integrarp.projeto_central_item_comentario(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_item_comentario_atualizado_em ON integrarp.projeto_central_item_comentario;
CREATE TRIGGER trg_projeto_central_item_comentario_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_item_comentario
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item_anexo (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_item_anexo ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_tenant_id ON integrarp.projeto_central_item_anexo(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_status ON integrarp.projeto_central_item_anexo(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_criado_em ON integrarp.projeto_central_item_anexo(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_setor_id ON integrarp.projeto_central_item_anexo(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_responsavel_usuario_id ON integrarp.projeto_central_item_anexo(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_prioridade ON integrarp.projeto_central_item_anexo(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_sprint_id ON integrarp.projeto_central_item_anexo(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_item_anexo_atualizado_em ON integrarp.projeto_central_item_anexo;
CREATE TRIGGER trg_projeto_central_item_anexo_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_item_anexo
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.projeto_central_evento_feed (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NULL,
  nome text NULL,
  codigo text NULL,
  status text NOT NULL DEFAULT 'ativo',
  prioridade text NULL,
  responsavel_usuario_id uuid NULL,
  setor_id uuid NULL,
  sprint_id uuid NULL,
  dados jsonb NOT NULL DEFAULT '{}'::jsonb,
  metadados jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  criado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  atualizado_por_usuario_id uuid NULL,
  excluido_em timestamptz NULL
);

ALTER TABLE integrarp.projeto_central_evento_feed ADD COLUMN IF NOT EXISTS busca_textual tsvector;
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_tenant_id ON integrarp.projeto_central_evento_feed(tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_status ON integrarp.projeto_central_evento_feed(status);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_criado_em ON integrarp.projeto_central_evento_feed(criado_em);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_setor_id ON integrarp.projeto_central_evento_feed(setor_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_responsavel_usuario_id ON integrarp.projeto_central_evento_feed(responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_prioridade ON integrarp.projeto_central_evento_feed(prioridade);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_sprint_id ON integrarp.projeto_central_evento_feed(sprint_id);
DROP TRIGGER IF EXISTS trg_projeto_central_evento_feed_atualizado_em ON integrarp.projeto_central_evento_feed;
CREATE TRIGGER trg_projeto_central_evento_feed_atualizado_em
BEFORE UPDATE ON integrarp.projeto_central_evento_feed
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_projeto_central_resumo AS
SELECT
  board.id AS board_id,
  board.nome AS board_nome,
  count(item.id) AS total_itens
FROM integrarp.projeto_central_board board
LEFT JOIN integrarp.projeto_central_item item ON item.tenant_id = board.tenant_id
GROUP BY board.id, board.nome;

INSERT INTO integrarp.setor (nome, codigo) SELECT 'Diretoria Executiva', lower(regexp_replace('Diretoria Executiva', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Diretoria Executiva');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Administrativo / Financeiro', lower(regexp_replace('Administrativo / Financeiro', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Administrativo / Financeiro');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Marketing', lower(regexp_replace('Marketing', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Marketing');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Vendas', lower(regexp_replace('Vendas', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Vendas');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Trade Marketing / Promotor de Vendas', lower(regexp_replace('Trade Marketing / Promotor de Vendas', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Trade Marketing / Promotor de Vendas');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Logística', lower(regexp_replace('Logística', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Logística');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Entregas e Transporte', lower(regexp_replace('Entregas e Transporte', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Entregas e Transporte');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Serviços Gerais', lower(regexp_replace('Serviços Gerais', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Serviços Gerais');
INSERT INTO integrarp.setor (nome, codigo) SELECT 'Motorista', lower(regexp_replace('Motorista', '[^a-zA-Z0-9]+', '-', 'g')) WHERE NOT EXISTS (SELECT 1 FROM integrarp.setor WHERE nome = 'Motorista');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Pedido ao Pós-venda', lower(regexp_replace('Pedido ao Pós-venda', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Pedido ao Pós-venda');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Emissão de Boletos', lower(regexp_replace('Emissão de Boletos', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Emissão de Boletos');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Lançamento de Pedido', lower(regexp_replace('Lançamento de Pedido', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Lançamento de Pedido');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Separação de Pedido', lower(regexp_replace('Separação de Pedido', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Separação de Pedido');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Saída de Nota Fiscal / Expedição', lower(regexp_replace('Saída de Nota Fiscal / Expedição', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Saída de Nota Fiscal / Expedição');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Romaneio e Entrega', lower(regexp_replace('Romaneio e Entrega', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Romaneio e Entrega');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Prova de Entrega', lower(regexp_replace('Prova de Entrega', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Prova de Entrega');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Pós-vendas', lower(regexp_replace('Pós-vendas', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Pós-vendas');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Controle de Avaria e Devolução', lower(regexp_replace('Controle de Avaria e Devolução', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Controle de Avaria e Devolução');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Atualização de Produto no Catálogo', lower(regexp_replace('Atualização de Produto no Catálogo', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Atualização de Produto no Catálogo');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Ação de Vendas', lower(regexp_replace('Ação de Vendas', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Ação de Vendas');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Checagem de Estoque', lower(regexp_replace('Checagem de Estoque', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Checagem de Estoque');
INSERT INTO integrarp.processo_definicao (nome, codigo, status) SELECT 'Precificação no Ponto de Venda', lower(regexp_replace('Precificação no Ponto de Venda', '[^a-zA-Z0-9]+', '-', 'g')), 'template' WHERE NOT EXISTS (SELECT 1 FROM integrarp.processo_definicao WHERE nome = 'Precificação no Ponto de Venda');

-- <<< 0001_initial_integrarp.sql

-- >>> 0003_flow_bpmn_core.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE OR REPLACE FUNCTION integrarp.set_atualizado_em()
RETURNS trigger AS $$
BEGIN
  NEW.atualizado_em = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.processo_definicao (
  processo_definicao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  codigo varchar(120) NOT NULL,
  nome varchar(180) NOT NULL,
  descricao text NULL,
  modulo_origem varchar(80) NULL,
  setor_dono_id uuid NULL,
  status varchar(30) NOT NULL DEFAULT 'rascunho',
  versao_publicada_id uuid NULL,
  criado_por_usuario_id uuid NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_por_usuario_id uuid NULL,
  atualizado_em timestamptz NULL,
  excluido_em timestamptz NULL,
  metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_processo_definicao_tenant_codigo ON integrarp.processo_definicao (tenant_id, codigo) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.processo_versao (
  processo_versao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  processo_definicao_id uuid NOT NULL,
  numero_versao int NOT NULL,
  status varchar(30) NOT NULL,
  publicado_em timestamptz NULL,
  publicado_por_usuario_id uuid NULL,
  bpmn_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NULL,
  excluido_em timestamptz NULL
);
CREATE INDEX IF NOT EXISTS ix_processo_versao_tenant_definicao ON integrarp.processo_versao (tenant_id, processo_definicao_id);

CREATE TABLE IF NOT EXISTS integrarp.processo_elemento (
  processo_elemento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  processo_versao_id uuid NOT NULL,
  codigo varchar(120) NOT NULL,
  nome varchar(180) NOT NULL,
  tipo varchar(40) NOT NULL,
  descricao text NULL,
  setor_responsavel_id uuid NULL,
  usuario_responsavel_id uuid NULL,
  perfil_responsavel_id uuid NULL,
  sla_minutos int NULL,
  formulario_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  checklist_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  regra_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  posicao_x numeric(12,2) NULL,
  posicao_y numeric(12,2) NULL,
  ordem numeric(12,4) NOT NULL DEFAULT 0,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NULL,
  excluido_em timestamptz NULL
);
CREATE INDEX IF NOT EXISTS ix_processo_elemento_tenant_versao ON integrarp.processo_elemento (tenant_id, processo_versao_id);

CREATE TABLE IF NOT EXISTS integrarp.processo_transicao (
  processo_transicao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  processo_versao_id uuid NOT NULL,
  elemento_origem_id uuid NOT NULL,
  elemento_destino_id uuid NOT NULL,
  codigo varchar(120) NOT NULL,
  nome varchar(180) NULL,
  condicao_tipo varchar(40) NOT NULL DEFAULT 'always',
  condicao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  ordem numeric(12,4) NOT NULL DEFAULT 0,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NULL,
  excluido_em timestamptz NULL
);
CREATE INDEX IF NOT EXISTS ix_processo_transicao_tenant_versao ON integrarp.processo_transicao (tenant_id, processo_versao_id);

CREATE TABLE IF NOT EXISTS integrarp.processo_instancia (
  processo_instancia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  processo_definicao_id uuid NOT NULL,
  processo_versao_id uuid NOT NULL,
  codigo varchar(80) NOT NULL,
  titulo varchar(220) NOT NULL,
  status varchar(40) NOT NULL,
  elemento_atual_id uuid NULL,
  origem_tipo varchar(60) NULL,
  origem_id uuid NULL,
  iniciado_por_usuario_id uuid NULL,
  iniciado_em timestamptz NOT NULL DEFAULT now(),
  concluido_em timestamptz NULL,
  cancelado_em timestamptz NULL,
  prazo_em timestamptz NULL,
  contexto_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NULL,
  excluido_em timestamptz NULL
);
CREATE INDEX IF NOT EXISTS ix_processo_instancia_tenant_status ON integrarp.processo_instancia (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.processo_variavel (
  processo_variavel_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  processo_instancia_id uuid NOT NULL,
  nome varchar(120) NOT NULL,
  tipo varchar(40) NOT NULL,
  valor_texto text NULL,
  valor_numero numeric(18,4) NULL,
  valor_data timestamptz NULL,
  valor_booleano boolean NULL,
  valor_json jsonb NULL,
  criado_em timestamptz NOT NULL DEFAULT now(),
  atualizado_em timestamptz NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_processo_variavel_tenant_instancia_nome ON integrarp.processo_variavel (tenant_id, processo_instancia_id, nome);

CREATE TABLE IF NOT EXISTS integrarp.processo_sla_politica (processo_sla_politica_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, processo_elemento_id uuid NULL, sla_minutos int NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.processo_evento_vinculo (processo_evento_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, processo_definicao_id uuid NOT NULL, tipo_evento varchar(120) NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.processo_auditoria_evento (processo_auditoria_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, processo_definicao_id uuid NULL, processo_versao_id uuid NULL, processo_instancia_id uuid NULL, tarefa_id uuid NULL, tipo_evento varchar(120) NOT NULL, descricao text NOT NULL, antes_json jsonb NULL, depois_json jsonb NULL, correlation_id varchar(120) NULL, criado_em timestamptz NOT NULL DEFAULT now());

CREATE TABLE IF NOT EXISTS integrarp.tarefa (
  tarefa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, processo_instancia_id uuid NULL, processo_elemento_id uuid NULL, codigo varchar(80) NOT NULL, titulo varchar(220) NOT NULL, descricao text NULL, status varchar(40) NOT NULL, prioridade varchar(20) NOT NULL DEFAULT 'media', setor_responsavel_id uuid NULL, usuario_responsavel_id uuid NULL, perfil_responsavel_id uuid NULL, assumida_por_usuario_id uuid NULL, assumida_em timestamptz NULL, concluida_por_usuario_id uuid NULL, concluida_em timestamptz NULL, prazo_em timestamptz NULL, formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb, checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_por_usuario_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL
);
CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_status ON integrarp.tarefa (tenant_id, status);
CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (tarefa_comentario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NULL, comentario text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.tarefa_anexo (tarefa_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NULL, nome_arquivo varchar(260) NOT NULL, url text NOT NULL, content_type varchar(120) NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.evento_negocio (evento_negocio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo_evento varchar(120) NOT NULL, origem_tipo varchar(80) NULL, origem_id uuid NULL, processo_instancia_id uuid NULL, tarefa_id uuid NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status varchar(40) NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), processado_em timestamptz NULL, erro text NULL);
CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (outbox_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo_evento varchar(120) NOT NULL, canal varchar(60) NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status varchar(40) NOT NULL DEFAULT 'pendente', tentativas int NOT NULL DEFAULT 0, proxima_tentativa_em timestamptz NULL, processado_em timestamptz NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now());

CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_abertas AS SELECT tenant_id, tarefa_id, codigo, titulo, status, prioridade, prazo_em FROM integrarp.tarefa WHERE excluido_em IS NULL AND status IN ('aberta','atribuida','em_andamento');
CREATE OR REPLACE VIEW integrarp.vw_flow_tarefas_atrasadas AS SELECT tenant_id, tarefa_id, codigo, titulo, status, prioridade, prazo_em FROM integrarp.tarefa WHERE excluido_em IS NULL AND status <> 'concluida' AND prazo_em < now();
CREATE OR REPLACE VIEW integrarp.vw_flow_processos_em_andamento AS SELECT tenant_id, processo_instancia_id, codigo, titulo, status, prazo_em FROM integrarp.processo_instancia WHERE excluido_em IS NULL AND status IN ('em_andamento','aguardando_tarefa');
CREATE OR REPLACE VIEW integrarp.vw_flow_processos_atrasados AS SELECT tenant_id, processo_instancia_id, codigo, titulo, status, prazo_em FROM integrarp.processo_instancia WHERE excluido_em IS NULL AND status <> 'concluido' AND prazo_em < now();
CREATE OR REPLACE VIEW integrarp.vw_flow_dashboard_resumo AS SELECT d.tenant_id, count(DISTINCT d.processo_definicao_id) FILTER (WHERE d.status = 'publicado') AS processos_publicados, count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status IN ('em_andamento','aguardando_tarefa')) AS processos_em_andamento, count(DISTINCT t.tarefa_id) FILTER (WHERE t.status IN ('aberta','atribuida','em_andamento')) AS tarefas_abertas, count(DISTINCT t.tarefa_id) FILTER (WHERE t.status <> 'concluida' AND t.prazo_em < now()) AS tarefas_atrasadas, count(DISTINCT i.processo_instancia_id) FILTER (WHERE i.status = 'concluido') AS processos_concluidos FROM integrarp.processo_definicao d LEFT JOIN integrarp.processo_instancia i ON i.tenant_id = d.tenant_id AND i.processo_definicao_id = d.processo_definicao_id AND i.excluido_em IS NULL LEFT JOIN integrarp.tarefa t ON t.tenant_id = d.tenant_id AND t.excluido_em IS NULL WHERE d.excluido_em IS NULL GROUP BY d.tenant_id;

DROP TRIGGER IF EXISTS trg_tarefa_atualizado_em ON integrarp.tarefa;
CREATE TRIGGER trg_tarefa_atualizado_em BEFORE UPDATE ON integrarp.tarefa FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

INSERT INTO integrarp.processo_definicao (tenant_id, codigo, nome, descricao, status, metadata_json)
VALUES ('11111111-1111-1111-1111-111111111111', 'pedido_ao_pos_venda', 'Pedido ao Pós-venda', 'Seed Integra Flow: do pedido ao faturamento.', 'publicado', '{"initialVariables":["cliente_id","pedido_id","valor_pedido","credito_aprovado","estoque_disponivel","observacao"]}'::jsonb)
ON CONFLICT DO NOTHING;

-- <<< 0003_flow_bpmn_core.sql

-- >>> 0004_flow_designer_web.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS designer_layout_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS designer_validacao_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS ultima_validacao_em timestamptz NULL;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS designer_config_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS designer_config_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE TABLE IF NOT EXISTS integrarp.flow_template (
    flow_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    categoria varchar(80) NOT NULL,
    setor_sugerido varchar(120) NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    publico boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    template_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.flow_template_elemento (
    flow_template_elemento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_template_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    tipo varchar(40) NOT NULL,
    descricao text NULL,
    setor_sugerido varchar(120) NULL,
    sla_minutos int NULL,
    formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    regra_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    posicao_x numeric(12,2) NULL,
    posicao_y numeric(12,2) NULL,
    ordem numeric(12,4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS integrarp.flow_template_transicao (
    flow_template_transicao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_template_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    origem_codigo varchar(120) NOT NULL,
    destino_codigo varchar(120) NOT NULL,
    nome varchar(180) NULL,
    condicao_tipo varchar(40) NOT NULL DEFAULT 'always',
    condicao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ordem numeric(12,4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS integrarp.flow_designer_historico (
    flow_designer_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_definicao_id uuid NOT NULL,
    processo_versao_id uuid NOT NULL,
    usuario_id uuid NULL,
    acao varchar(80) NOT NULL,
    descricao text NULL,
    antes_json jsonb NULL,
    depois_json jsonb NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    correlation_id varchar(120) NULL
);

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_flow_template_tenant_codigo') THEN
        ALTER TABLE integrarp.flow_template ADD CONSTRAINT uq_flow_template_tenant_codigo UNIQUE (tenant_id, codigo);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_flow_template_elemento_template') THEN
        ALTER TABLE integrarp.flow_template_elemento ADD CONSTRAINT fk_flow_template_elemento_template FOREIGN KEY (flow_template_id) REFERENCES integrarp.flow_template(flow_template_id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_flow_template_transicao_template') THEN
        ALTER TABLE integrarp.flow_template_transicao ADD CONSTRAINT fk_flow_template_transicao_template FOREIGN KEY (flow_template_id) REFERENCES integrarp.flow_template(flow_template_id) ON DELETE CASCADE;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_flow_template_categoria ON integrarp.flow_template(categoria) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_flow_template_elemento_template ON integrarp.flow_template_elemento(flow_template_id);
CREATE INDEX IF NOT EXISTS ix_flow_template_transicao_template ON integrarp.flow_template_transicao(flow_template_id);
CREATE INDEX IF NOT EXISTS ix_flow_designer_historico_versao ON integrarp.flow_designer_historico(processo_versao_id, criado_em DESC);

CREATE OR REPLACE FUNCTION integrarp.fn_flow_designer_touch_template() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_flow_template_touch ON integrarp.flow_template;
CREATE TRIGGER trg_flow_template_touch BEFORE UPDATE ON integrarp.flow_template FOR EACH ROW EXECUTE FUNCTION integrarp.fn_flow_designer_touch_template();

CREATE OR REPLACE VIEW integrarp.vw_flow_template_catalogo AS
SELECT flow_template_id, tenant_id, codigo, nome, categoria, setor_sugerido, icone, cor, publico, ativo
FROM integrarp.flow_template
WHERE excluido_em IS NULL;

INSERT INTO integrarp.flow_template (codigo, nome, descricao, categoria, setor_sugerido, icone, cor, publico, ativo, template_json)
VALUES
('pedido_ao_pos_venda','Pedido ao Pós-venda','Fluxo do pedido até pós-venda.','Operação Comercial','Vendas, Administrativo/Financeiro, Logística, Entregas','diagram','#2563EB',true,true,'{}'),
('emissao_de_boletos','Emissão de Boletos','Geração e envio de boleto.','Financeiro','Financeiro','receipt','#2563EB',true,true,'{}'),
('lancamento_de_pedidos_no_sistema','Lançamento de Pedidos no Sistema','Lançamento no ERP.','Administrativo / Financeiro','Administrativo/Financeiro','clipboard','#2563EB',true,true,'{}'),
('emissao_e_faturamento_de_notas_fiscais','Emissão e Faturamento de Notas Fiscais','Faturamento e NF.','Financeiro / Faturamento','Financeiro/Faturamento','file-invoice','#2563EB',true,true,'{}'),
('atualizacao_de_produtos_no_catalogo','Atualização de Produtos no Catálogo','Atualização de conteúdo de produtos.','Marketing','Marketing','box','#2563EB',true,true,'{}'),
('planejamento_semanal_de_vendas','Planejamento Semanal de Vendas','Planejamento semanal de visitas e vendas.','Vendas','Vendas','calendar','#2563EB',true,true,'{}'),
('visita_a_clientes','Visita a Clientes','Rotina de visita a clientes.','Vendas','Vendas','users','#2563EB',true,true,'{}'),
('pos_vendas','Pós-vendas','Acompanhamento pós-entrega.','Vendas','Vendas','phone','#2563EB',true,true,'{}'),
('arrumacao_do_ponto_de_venda','Arrumação do Ponto de Venda','Organização do PV.','Trade Marketing','Trade Marketing','store','#2563EB',true,true,'{}'),
('checagem_de_estoque','Checagem de Estoque','Conferência de estoque.','Trade Marketing / Estoque','Trade Marketing/Estoque','warehouse','#2563EB',true,true,'{}'),
('precificacao','Precificação','Controle de etiquetas e promoções.','Trade Marketing','Trade Marketing','tag','#2563EB',true,true,'{}'),
('recebimento_de_notas_fiscais','Recebimento de Notas Fiscais','Recebimento logístico.','Logística','Logística','truck','#2563EB',true,true,'{}'),
('separacao_de_pedidos','Separação de Pedidos','Separação e expedição.','Logística','Logística','boxes','#2563EB',true,true,'{}'),
('saida_de_notas_fiscais_expedicao','Saída de Notas Fiscais / Expedição','Conferência de romaneio e saída.','Logística','Logística','send','#2563EB',true,true,'{}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.flow_template_elemento (flow_template_id, codigo, nome, tipo, descricao, setor_sugerido, sla_minutos, formulario_schema_json, checklist_schema_json, posicao_x, posicao_y, ordem)
SELECT t.flow_template_id, e.codigo, e.nome, e.tipo, e.descricao, t.setor_sugerido, e.sla_minutos, e.formulario_schema_json::jsonb, e.checklist_schema_json::jsonb, e.posicao_x, e.posicao_y, e.ordem
FROM integrarp.flow_template t
CROSS JOIN (VALUES
('inicio','Início','start_event','Evento de início',NULL,'{"fields":[]}','[]',80,120,0),
('atividade_1','Executar etapa operacional','human_task','Etapa humana principal',240,'{"fields":[{"code":"observacao","label":"Observação","type":"textarea","required":false,"options":[],"order":1}]}','[{"code":"confirmar","title":"Confirmar execução","required":true,"order":1}]',320,120,1),
('decisao','Conferência necessária?','gateway','Decisão simples',NULL,'{"fields":[]}','[]',560,120,2),
('fim','Fim','end_event','Evento de fim',NULL,'{"fields":[]}','[]',820,120,3)
) AS e(codigo,nome,tipo,descricao,sla_minutos,formulario_schema_json,checklist_schema_json,posicao_x,posicao_y,ordem)
WHERE NOT EXISTS (SELECT 1 FROM integrarp.flow_template_elemento x WHERE x.flow_template_id = t.flow_template_id AND x.codigo = e.codigo);

INSERT INTO integrarp.flow_template_transicao (flow_template_id, codigo, origem_codigo, destino_codigo, nome, condicao_tipo, condicao_json, ordem)
SELECT t.flow_template_id, e.codigo, e.origem_codigo, e.destino_codigo, e.nome, e.condicao_tipo, e.condicao_json::jsonb, e.ordem
FROM integrarp.flow_template t
CROSS JOIN (VALUES
('t_inicio_atividade','inicio','atividade_1','Iniciar','always','{}',1),
('t_atividade_decisao','atividade_1','decisao','Conferir','always','{}',2),
('t_decisao_fim','decisao','fim','Finalizar','always','{}',3)
) AS e(codigo,origem_codigo,destino_codigo,nome,condicao_tipo,condicao_json,ordem)
WHERE NOT EXISTS (SELECT 1 FROM integrarp.flow_template_transicao x WHERE x.flow_template_id = t.flow_template_id AND x.codigo = e.codigo);

-- Permissões do designer devem ser vinculadas ao catálogo RBAC quando a tabela de permissões estiver habilitada.

-- <<< 0004_flow_designer_web.sql

-- >>> 0006_faturamento_connect_outbox.sql
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.fatura (
    fatura_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    filial_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    codigo varchar(80) NOT NULL,
    numero varchar(80) NULL,
    status varchar(40) NOT NULL DEFAULT 'rascunho',
    data_emissao timestamptz NULL,
    data_vencimento date NULL,
    valor_bruto numeric(18,2) NOT NULL DEFAULT 0,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_acrescimo numeric(18,2) NOT NULL DEFAULT 0,
    valor_total numeric(18,2) NOT NULL DEFAULT 0,
    observacao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.fatura_item (
    fatura_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NOT NULL,
    pedido_item_id uuid NULL,
    produto_id uuid NULL,
    descricao varchar(260) NOT NULL,
    quantidade numeric(18,4) NOT NULL DEFAULT 1,
    valor_unitario numeric(18,2) NOT NULL DEFAULT 0,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_total numeric(18,2) NOT NULL DEFAULT 0,
    ordem numeric(12,4) NOT NULL DEFAULT 0,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (
    titulo_financeiro_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    filial_id uuid NULL,
    fatura_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    codigo varchar(80) NOT NULL,
    tipo varchar(40) NOT NULL DEFAULT 'receber',
    origem varchar(60) NULL,
    status varchar(40) NOT NULL DEFAULT 'aberto',
    descricao varchar(260) NOT NULL,
    data_emissao date NOT NULL DEFAULT current_date,
    data_vencimento date NOT NULL,
    data_pagamento date NULL,
    valor_original numeric(18,2) NOT NULL,
    valor_desconto numeric(18,2) NOT NULL DEFAULT 0,
    valor_acrescimo numeric(18,2) NOT NULL DEFAULT 0,
    valor_pago numeric(18,2) NOT NULL DEFAULT 0,
    valor_aberto numeric(18,2) NOT NULL,
    forma_pagamento varchar(60) NULL,
    link_boleto text NULL,
    linha_digitavel text NULL,
    codigo_barras text NULL,
    nosso_numero varchar(120) NULL,
    observacao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro_historico (
    titulo_financeiro_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    tipo_evento varchar(80) NOT NULL,
    descricao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.boleto_log (
    boleto_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    provedor varchar(80) NOT NULL DEFAULT 'fake',
    status varchar(40) NOT NULL,
    request_json jsonb NULL,
    response_json jsonb NULL,
    link_boleto text NULL,
    linha_digitavel text NULL,
    codigo_barras text NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.nota_fiscal_referencia (
    nota_fiscal_referencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NULL,
    pedido_id uuid NULL,
    cliente_id uuid NOT NULL,
    tipo varchar(40) NOT NULL DEFAULT 'nfe',
    status varchar(40) NOT NULL DEFAULT 'referenciada',
    numero varchar(80) NULL,
    serie varchar(40) NULL,
    chave_acesso varchar(120) NULL,
    data_emissao timestamptz NULL,
    valor_total numeric(18,2) NULL,
    xml_storage_key text NULL,
    danfe_storage_key text NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.documento_faturamento (
    documento_faturamento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fatura_id uuid NULL,
    nota_fiscal_referencia_id uuid NULL,
    nome_arquivo varchar(260) NOT NULL,
    storage_key text NOT NULL,
    content_type varchar(120) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.cobranca_evento (
    cobranca_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    titulo_financeiro_id uuid NOT NULL,
    tipo varchar(80) NOT NULL,
    descricao text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.financeiro_configuracao (
    financeiro_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    dias_vencimento_padrao int NOT NULL DEFAULT 7,
    permitir_boleto_fake boolean NOT NULL DEFAULT true,
    permitir_nf_fake boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_template (
    mensagem_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    canal varchar(40) NOT NULL,
    categoria varchar(80) NOT NULL,
    assunto_template varchar(260) NULL,
    corpo_template text NOT NULL,
    variaveis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    publico boolean NOT NULL DEFAULT false,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_envio (
    mensagem_envio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    template_id uuid NULL,
    outbox_evento_id uuid NULL,
    canal varchar(40) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    assunto varchar(260) NULL,
    corpo_renderizado text NOT NULL,
    origem_tipo varchar(80) NULL,
    origem_id uuid NULL,
    erro text NULL,
    tentativas int NOT NULL DEFAULT 0,
    enviado_em timestamptz NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.mensagem_envio_destinatario (
    mensagem_envio_destinatario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    mensagem_envio_id uuid NOT NULL,
    destinatario varchar(260) NOT NULL,
    nome varchar(180) NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.canal_conversa (
    canal_conversa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    canal varchar(40) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'aberta',
    cliente_id uuid NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.canal_conversa_mensagem (
    canal_conversa_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    canal_conversa_id uuid NOT NULL,
    direcao varchar(40) NOT NULL,
    corpo text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'registrada',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_webhook_endpoint (
    connect_webhook_endpoint_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome varchar(180) NOT NULL,
    url text NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'ativo',
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_webhook_evento (
    connect_webhook_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    connect_webhook_endpoint_id uuid NULL,
    tipo_evento varchar(120) NOT NULL,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.connect_configuracao (
    connect_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fake_providers_ativos boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (
    outbox_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo_evento varchar(120) NOT NULL,
    canal varchar(60) NULL,
    origem_tipo varchar(80) NULL,
    origem_id uuid NULL,
    prioridade varchar(20) NOT NULL DEFAULT 'normal',
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    status varchar(40) NOT NULL DEFAULT 'pendente',
    tentativas int NOT NULL DEFAULT 0,
    max_tentativas int NOT NULL DEFAULT 5,
    proxima_tentativa_em timestamptz NULL,
    processado_em timestamptz NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    correlation_id varchar(120) NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (
    outbox_processamento_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    outbox_evento_id uuid NOT NULL,
    status varchar(40) NOT NULL,
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_faturamento_vinculo (
    pedido_faturamento_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    fatura_id uuid NULL,
    titulo_financeiro_id uuid NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.flow_faturamento_vinculo (
    flow_faturamento_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    processo_instancia_id uuid NULL,
    tarefa_id uuid NULL,
    pedido_id uuid NULL,
    fatura_id uuid NULL,
    titulo_financeiro_id uuid NULL,
    nota_fiscal_referencia_id uuid NULL,
    status varchar(40) NOT NULL DEFAULT 'criado',
    erro text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_mensagem_template_tenant_canal_codigo') THEN
        ALTER TABLE integrarp.mensagem_template ADD CONSTRAINT uq_mensagem_template_tenant_canal_codigo UNIQUE (tenant_id, canal, codigo);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mensagem_template_tenant_canal_codigo_idx ON integrarp.mensagem_template (coalesce(tenant_id, '00000000-0000-0000-0000-000000000000'::uuid), canal, codigo);
CREATE INDEX IF NOT EXISTS ix_fatura_tenant_status ON integrarp.fatura (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_titulo_tenant_status ON integrarp.titulo_financeiro (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_mensagem_envio_tenant_status ON integrarp.mensagem_envio (tenant_id, status);
CREATE INDEX IF NOT EXISTS ix_outbox_tenant_status ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em);

DROP TRIGGER IF EXISTS trg_fatura_atualizado_em ON integrarp.fatura;
CREATE TRIGGER trg_fatura_atualizado_em BEFORE UPDATE ON integrarp.fatura FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();
DROP TRIGGER IF EXISTS trg_titulo_atualizado_em ON integrarp.titulo_financeiro;
CREATE TRIGGER trg_titulo_atualizado_em BEFORE UPDATE ON integrarp.titulo_financeiro FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_titulos_em_aberto AS
SELECT tenant_id, titulo_financeiro_id, codigo, cliente_id, data_vencimento, valor_aberto
FROM integrarp.titulo_financeiro
WHERE excluido_em IS NULL AND status IN ('aberto', 'enviado', 'pago_parcial');

CREATE OR REPLACE VIEW integrarp.vw_titulos_vencidos AS
SELECT tenant_id, titulo_financeiro_id, codigo, cliente_id, data_vencimento, valor_aberto
FROM integrarp.titulo_financeiro
WHERE excluido_em IS NULL AND status = 'vencido';

CREATE OR REPLACE VIEW integrarp.vw_outbox_pendente AS
SELECT tenant_id, outbox_evento_id, tipo_evento, canal, origem_tipo, origem_id, prioridade, tentativas, criado_em
FROM integrarp.outbox_evento
WHERE excluido_em IS NULL AND status = 'pendente';

CREATE OR REPLACE VIEW integrarp.vw_outbox_erros AS
SELECT tenant_id, outbox_evento_id, tipo_evento, canal, tentativas, max_tentativas, erro, criado_em
FROM integrarp.outbox_evento
WHERE excluido_em IS NULL AND status = 'erro';

CREATE OR REPLACE VIEW integrarp.vw_faturamento_por_status AS
SELECT tenant_id, status, count(*) AS total, coalesce(sum(valor_total), 0) AS valor_total
FROM integrarp.fatura
WHERE excluido_em IS NULL
GROUP BY tenant_id, status;

CREATE OR REPLACE VIEW integrarp.vw_financeiro_dashboard AS
SELECT
    f.tenant_id,
    coalesce(sum(f.valor_total) FILTER (WHERE date_trunc('month', f.data_emissao) = date_trunc('month', now())), 0) AS total_faturado_mes,
    count(*) FILTER (WHERE f.status = 'emitida') AS faturas_emitidas,
    (SELECT count(*) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status IN ('aberto', 'enviado')) AS titulos_em_aberto,
    (SELECT count(*) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status = 'vencido') AS titulos_vencidos,
    (SELECT coalesce(sum(t.valor_aberto), 0) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status IN ('aberto', 'enviado')) AS valor_em_aberto,
    (SELECT coalesce(sum(t.valor_aberto), 0) FROM integrarp.titulo_financeiro t WHERE t.tenant_id = f.tenant_id AND t.status = 'vencido') AS valor_vencido
FROM integrarp.fatura f
WHERE f.excluido_em IS NULL
GROUP BY f.tenant_id;

CREATE OR REPLACE VIEW integrarp.vw_connect_dashboard AS
SELECT
    coalesce(m.tenant_id, o.tenant_id) AS tenant_id,
    count(m.*) FILTER (WHERE m.status = 'pendente') AS mensagens_pendentes,
    count(m.*) FILTER (WHERE m.status = 'enviado') AS mensagens_enviadas,
    count(m.*) FILTER (WHERE m.status = 'erro') AS mensagens_com_erro,
    count(o.*) FILTER (WHERE o.status = 'pendente') AS outbox_pendente,
    count(o.*) FILTER (WHERE o.status = 'processado') AS outbox_processado,
    count(o.*) FILTER (WHERE o.status = 'erro') AS outbox_com_erro
FROM integrarp.mensagem_envio m
FULL JOIN integrarp.outbox_evento o ON o.tenant_id = m.tenant_id
GROUP BY coalesce(m.tenant_id, o.tenant_id);

INSERT INTO integrarp.financeiro_configuracao (tenant_id, dias_vencimento_padrao, permitir_boleto_fake, permitir_nf_fake)
SELECT '00000000-0000-0000-0000-000000000001', 7, true, true
WHERE NOT EXISTS (SELECT 1 FROM integrarp.financeiro_configuracao WHERE tenant_id = '00000000-0000-0000-0000-000000000001');

INSERT INTO integrarp.mensagem_template (tenant_id, codigo, nome, canal, categoria, assunto_template, corpo_template, publico)
VALUES
(NULL, 'pedido_confirmado_email', 'Pedido confirmado', 'email', 'pedido', 'Pedido {{pedido_codigo}} confirmado', 'Olá {{cliente_nome}}, seu pedido {{pedido_codigo}} foi confirmado.', true),
(NULL, 'fatura_emitida_email', 'Fatura emitida', 'email', 'faturamento', 'Fatura {{fatura_codigo}} emitida', 'Olá {{cliente_nome}}, sua fatura {{fatura_codigo}} vence em {{data_vencimento}}.', true),
(NULL, 'boleto_gerado_email', 'Boleto gerado', 'email', 'cobranca', 'Boleto {{fatura_codigo}}', 'Boleto fake/log: {{link_boleto}}.', true),
(NULL, 'titulo_vencendo_email', 'Título vencendo', 'email', 'cobranca', 'Título vencendo', 'Seu título vence em {{data_vencimento}}.', true),
(NULL, 'titulo_vencido_email', 'Título vencido', 'email', 'cobranca', 'Título vencido', 'Seu título venceu. Valor: {{valor_total}}.', true),
(NULL, 'pedido_enviado_logistica_email', 'Pedido para logística', 'email', 'logistica', 'Pedido faturado', 'Pedido {{pedido_codigo}} liberado para logística.', true),
(NULL, 'pedido_confirmado_whatsapp', 'Pedido confirmado WhatsApp', 'whatsapp', 'pedido', NULL, 'FAKE-WHATSAPP Pedido {{pedido_codigo}} confirmado.', true),
(NULL, 'fatura_emitida_whatsapp', 'Fatura emitida WhatsApp', 'whatsapp', 'faturamento', NULL, 'FAKE-WHATSAPP Fatura {{fatura_codigo}} emitida.', true),
(NULL, 'boleto_gerado_whatsapp', 'Boleto gerado WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Boleto {{link_boleto}}.', true),
(NULL, 'titulo_vencendo_whatsapp', 'Título vencendo WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Vence em {{data_vencimento}}.', true),
(NULL, 'titulo_vencido_whatsapp', 'Título vencido WhatsApp', 'whatsapp', 'cobranca', NULL, 'FAKE-WHATSAPP Título vencido.', true),
(NULL, 'nova_tarefa_sistema', 'Nova tarefa', 'sistema', 'flow', NULL, 'Nova tarefa {{tarefa_codigo}} disponível.', true),
(NULL, 'tarefa_atrasada_sistema', 'Tarefa atrasada', 'sistema', 'flow', NULL, 'Tarefa {{tarefa_codigo}} atrasada.', true),
(NULL, 'faturamento_concluido_sistema', 'Faturamento concluído', 'sistema', 'faturamento', NULL, 'Faturamento concluído para pedido {{pedido_codigo}}.', true),
(NULL, 'erro_outbox_sistema', 'Erro outbox', 'sistema', 'outbox', NULL, 'Erro ao processar outbox {{outbox_evento_id}}.', true)
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.fatura (tenant_id, cliente_id, codigo, status, valor_total, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'FAT-DEMO-001', 'rascunho', 100.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.fatura WHERE codigo = 'FAT-DEMO-001');

INSERT INTO integrarp.titulo_financeiro (tenant_id, cliente_id, codigo, status, descricao, data_vencimento, valor_original, valor_aberto, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'TIT-DEMO-ABERTO', 'aberto', 'Título demo aberto', current_date + 7, 100.00, 100.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.titulo_financeiro WHERE codigo = 'TIT-DEMO-ABERTO');

INSERT INTO integrarp.titulo_financeiro (tenant_id, cliente_id, codigo, status, descricao, data_vencimento, valor_original, valor_aberto, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'TIT-DEMO-VENCIDO', 'vencido', 'Título demo vencido', current_date - 3, 75.00, 75.00, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.titulo_financeiro WHERE codigo = 'TIT-DEMO-VENCIDO');

INSERT INTO integrarp.outbox_evento (tenant_id, tipo_evento, canal, prioridade, status, payload_json, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'connect.mensagem.enfileirada', 'email', 'normal', 'pendente', '{"demo":true}'::jsonb, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.outbox_evento WHERE metadata_json->>'demo' = 'true' AND status = 'pendente');

INSERT INTO integrarp.outbox_evento (tenant_id, tipo_evento, canal, prioridade, status, tentativas, erro, payload_json, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'connect.mensagem.erro', 'email', 'alta', 'erro', 1, 'Erro fake demo', '{"demo":true}'::jsonb, '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.outbox_evento WHERE metadata_json->>'demo' = 'true' AND status = 'erro');

INSERT INTO integrarp.mensagem_envio (tenant_id, canal, status, assunto, corpo_renderizado, tentativas, enviado_em, metadata_json)
SELECT '00000000-0000-0000-0000-000000000001', 'email', 'enviado', 'Mensagem demo', 'FAKE-EMAIL enviado com sucesso.', 1, now(), '{"demo":true}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM integrarp.mensagem_envio WHERE metadata_json->>'demo' = 'true');

-- <<< 0006_faturamento_connect_outbox.sql

-- >>> 0007_bi_kpis_project_central.sql
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS integrarp.kpi_definicao (kpi_definicao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, modulo varchar(80) NOT NULL, categoria varchar(80) NULL, unidade varchar(40) NULL, formula_texto text NULL, query_referencia text NULL, direcao_melhor varchar(20) NOT NULL DEFAULT 'maior', frequencia_calculo varchar(40) NOT NULL DEFAULT 'diaria', ativo boolean NOT NULL DEFAULT true, publico boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.kpi_valor (kpi_valor_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, kpi_definicao_id uuid NOT NULL, referencia_tipo varchar(80) NULL, referencia_id uuid NULL, periodo_inicio timestamptz NOT NULL, periodo_fim timestamptz NOT NULL, valor_numero numeric(18,4) NULL, valor_texto text NULL, status varchar(40) NOT NULL DEFAULT 'neutro', calculado_em timestamptz NOT NULL DEFAULT now(), fonte varchar(120) NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.kpi_meta (kpi_meta_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, kpi_definicao_id uuid NOT NULL, referencia_tipo varchar(80) NULL, referencia_id uuid NULL, valor_meta numeric(18,4) NULL, faixa_positiva_min numeric(18,4) NULL, faixa_positiva_max numeric(18,4) NULL, faixa_neutra_min numeric(18,4) NULL, faixa_neutra_max numeric(18,4) NULL, faixa_negativa_min numeric(18,4) NULL, faixa_negativa_max numeric(18,4) NULL, inicio_vigencia date NOT NULL DEFAULT current_date, fim_vigencia date NULL, ativo boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.score_operacional (score_operacional_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, referencia_tipo varchar(80) NOT NULL, referencia_id uuid NULL, score numeric(10,2) NOT NULL DEFAULT 0, status varchar(40) NOT NULL DEFAULT 'neutro', componentes_json jsonb NOT NULL DEFAULT '{}'::jsonb, periodo_inicio timestamptz NOT NULL, periodo_fim timestamptz NOT NULL, calculado_em timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS integrarp.kpi_alerta (kpi_alerta_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.kpi_snapshot (kpi_snapshot_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.score_operacional (score_operacional_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.dashboard_configuracao (dashboard_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.dashboard_widget (dashboard_widget_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_salvo (relatorio_salvo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.analytics_evento (analytics_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.analytics_agregacao_log (analytics_agregacao_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, nome varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_board (board_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome varchar(160) NOT NULL, descricao text NULL, cor_principal varchar(20) NOT NULL DEFAULT '#2563EB', status varchar(40) NOT NULL DEFAULT 'ativo', criado_por_usuario_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_sprint (sprint_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NOT NULL, codigo varchar(20) NOT NULL, nome varchar(160) NOT NULL, objetivo text NULL, data_inicio date NOT NULL, data_fim date NOT NULL, status varchar(30) NOT NULL DEFAULT 'planejada', meta_pontos integer NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_coluna (coluna_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NOT NULL, nome varchar(120) NOT NULL, descricao text NULL, cor varchar(20) NOT NULL DEFAULT '#2563EB', ordem numeric(12,4) NOT NULL DEFAULT 0, limite_wip integer NULL, eh_conclusiva boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item (item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NOT NULL, coluna_id uuid NOT NULL, sprint_id uuid NULL, codigo varchar(40) NOT NULL, titulo varchar(220) NOT NULL, descricao text NULL, tipo varchar(40) NOT NULL DEFAULT 'tarefa', modulo varchar(80) NULL, prioridade varchar(20) NOT NULL DEFAULT 'media', story_points integer NOT NULL DEFAULT 0, cor varchar(20) NOT NULL DEFAULT '#2563EB', responsavel_nome varchar(120) NULL, responsavel_usuario_id uuid NULL, data_limite date NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, etiquetas_json jsonb NOT NULL DEFAULT '[]'::jsonb, campos_extras_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_por_usuario_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, concluido_em timestamptz NULL, excluido_em timestamptz NULL);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item_comentario (projeto_central_item_comentario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NULL, item_id uuid NULL, tipo varchar(80) NULL, conteudo text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_item_anexo (projeto_central_item_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NULL, item_id uuid NULL, tipo varchar(80) NULL, conteudo text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_evento_feed (projeto_central_evento_feed_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NULL, item_id uuid NULL, tipo varchar(80) NULL, conteudo text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_importacao (projeto_central_importacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NULL, item_id uuid NULL, tipo varchar(80) NULL, conteudo text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.projeto_central_exportacao (projeto_central_exportacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, board_id uuid NULL, item_id uuid NULL, tipo varchar(80) NULL, conteudo text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE INDEX IF NOT EXISTS ix_kpi_definicao_tenant ON integrarp.kpi_definicao (tenant_id);
CREATE INDEX IF NOT EXISTS ix_kpi_valor_tenant ON integrarp.kpi_valor (tenant_id);
CREATE INDEX IF NOT EXISTS ix_kpi_meta_tenant ON integrarp.kpi_meta (tenant_id);
CREATE INDEX IF NOT EXISTS ix_kpi_alerta_tenant ON integrarp.kpi_alerta (tenant_id);
CREATE INDEX IF NOT EXISTS ix_kpi_snapshot_tenant ON integrarp.kpi_snapshot (tenant_id);
CREATE INDEX IF NOT EXISTS ix_score_operacional_tenant ON integrarp.score_operacional (tenant_id);
CREATE INDEX IF NOT EXISTS ix_dashboard_configuracao_tenant ON integrarp.dashboard_configuracao (tenant_id);
CREATE INDEX IF NOT EXISTS ix_dashboard_widget_tenant ON integrarp.dashboard_widget (tenant_id);
CREATE INDEX IF NOT EXISTS ix_relatorio_salvo_tenant ON integrarp.relatorio_salvo (tenant_id);
CREATE INDEX IF NOT EXISTS ix_analytics_evento_tenant ON integrarp.analytics_evento (tenant_id);
CREATE INDEX IF NOT EXISTS ix_analytics_agregacao_log_tenant ON integrarp.analytics_agregacao_log (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_board_tenant ON integrarp.projeto_central_board (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_sprint_tenant ON integrarp.projeto_central_sprint (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_coluna_tenant ON integrarp.projeto_central_coluna (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_tenant ON integrarp.projeto_central_item (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_comentario_tenant ON integrarp.projeto_central_item_comentario (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_item_anexo_tenant ON integrarp.projeto_central_item_anexo (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_evento_feed_tenant ON integrarp.projeto_central_evento_feed (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_importacao_tenant ON integrarp.projeto_central_importacao (tenant_id);
CREATE INDEX IF NOT EXISTS ix_projeto_central_exportacao_tenant ON integrarp.projeto_central_exportacao (tenant_id);
CREATE OR REPLACE FUNCTION integrarp.fn_sprint7_touch_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$;
DROP TRIGGER IF EXISTS trg_kpi_definicao_updated_at ON integrarp.kpi_definicao;
CREATE TRIGGER trg_kpi_definicao_updated_at BEFORE UPDATE ON integrarp.kpi_definicao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_sprint7_touch_updated_at();
DROP TRIGGER IF EXISTS trg_projeto_central_board_updated_at ON integrarp.projeto_central_board;
CREATE TRIGGER trg_projeto_central_board_updated_at BEFORE UPDATE ON integrarp.projeto_central_board FOR EACH ROW EXECUTE FUNCTION integrarp.fn_sprint7_touch_updated_at();
DROP TRIGGER IF EXISTS trg_projeto_central_item_updated_at ON integrarp.projeto_central_item;
CREATE TRIGGER trg_projeto_central_item_updated_at BEFORE UPDATE ON integrarp.projeto_central_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_sprint7_touch_updated_at();
CREATE OR REPLACE VIEW integrarp.vw_bi_dashboard_executivo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_dashboard_executivo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_score_operacional AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_score_operacional'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_kpis_atuais AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_kpis_atuais'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_alertas_kpi AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_alertas_kpi'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_gargalos_operacionais AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_gargalos_operacionais'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_flow_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_flow_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_tarefas_atrasadas AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_tarefas_atrasadas'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_processos_atrasados AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_processos_atrasados'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_sla_por_setor AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_sla_por_setor'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_comercial_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_comercial_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_pedidos_por_status AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_pedidos_por_status'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_pedidos_em_fluxo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_pedidos_em_fluxo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_ticket_medio AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_ticket_medio'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_estoque_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_estoque_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_estoque_critico AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_estoque_critico'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_lotes_vencendo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_lotes_vencendo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_financeiro_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_financeiro_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_titulos_vencidos AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_titulos_vencidos'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_faturamento_mensal AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_faturamento_mensal'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_connect_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_connect_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_outbox_erros AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_outbox_erros'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_bi_mensagens_por_canal AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_bi_mensagens_por_canal'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_projeto_central_resumo AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_projeto_central_resumo'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_projeto_central_velocity AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_projeto_central_velocity'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_projeto_central_burndown AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_projeto_central_burndown'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_projeto_central_carga_por_responsavel AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_projeto_central_carga_por_responsavel'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
CREATE OR REPLACE VIEW integrarp.vw_projeto_central_itens_atrasados AS SELECT gen_random_uuid() AS id, NULL::uuid AS tenant_id, 'vw_projeto_central_itens_atrasados'::text AS indicador, 0::numeric AS valor, now() AS atualizado_em;
INSERT INTO integrarp.kpi_definicao (codigo,nome,modulo,unidade,publico) VALUES
('s7_1','Pedidos processados no prazo','Sprint7','quantidade',true),
('s7_2','Tempo médio de separação','Sprint7','quantidade',true),
('s7_3','Precisão de estoque','Sprint7','quantidade',true),
('s7_4','Entregas no prazo','Sprint7','quantidade',true),
('s7_5','Provas de entrega registradas','Sprint7','quantidade',true),
('s7_6','Títulos recebidos no prazo','Sprint7','quantidade',true),
('s7_7','Tempo de emissão de título/NF','Sprint7','quantidade',true),
('s7_8','Taxa de conversão','Sprint7','quantidade',true),
('s7_9','Satisfação do cliente','Sprint7','quantidade',true),
('s7_10','Tarefas atrasadas','Sprint7','quantidade',true),
('s7_11','Processos atrasados','Sprint7','quantidade',true),
('s7_12','SLA vencido','Sprint7','quantidade',true),
('s7_13','Estoque crítico','Sprint7','quantidade',true),
('s7_14','Outbox com erro','Sprint7','quantidade',true),
('s7_15','Velocity por sprint','Sprint7','quantidade',true),
('s7_16','Burndown saudável','Sprint7','quantidade',true) ON CONFLICT DO NOTHING;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_score_operacional_range') THEN ALTER TABLE integrarp.score_operacional ADD CONSTRAINT ck_score_operacional_range CHECK (score >= 0 AND score <= 100); END IF; END $$;

-- <<< 0007_bi_kpis_project_central.sql

-- >>> 0008_mobile_ai_mvp.sql
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.mobile_dispositivo (
    mobile_dispositivo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_dispositivo_tenant_status ON integrarp.mobile_dispositivo (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_sessao (
    mobile_sessao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_sessao_tenant_status ON integrarp.mobile_sessao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_notificacao (
    mobile_notificacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_notificacao_tenant_status ON integrarp.mobile_notificacao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_anexo (
    mobile_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_anexo_tenant_status ON integrarp.mobile_anexo (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_evidencia (
    mobile_evidencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_evidencia_tenant_status ON integrarp.mobile_evidencia (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_assinatura (
    mobile_assinatura_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_assinatura_tenant_status ON integrarp.mobile_assinatura (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_geo_evento (
    mobile_geo_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_geo_evento_tenant_status ON integrarp.mobile_geo_evento (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_sync_fila (
    mobile_sync_fila_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_sync_fila_tenant_status ON integrarp.mobile_sync_fila (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_execucao_tarefa (
    mobile_execucao_tarefa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_execucao_tarefa_tenant_status ON integrarp.mobile_execucao_tarefa (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.mobile_aprovacao (
    mobile_aprovacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_mobile_aprovacao_tenant_status ON integrarp.mobile_aprovacao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_agente (
    ai_agente_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_agente_tenant_status ON integrarp.ai_agente (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_intencao (
    ai_intencao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_intencao_tenant_status ON integrarp.ai_intencao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta (
    ai_ferramenta_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_tenant_status ON integrarp.ai_ferramenta (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_ferramenta_permissao (
    ai_ferramenta_permissao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_ferramenta_permissao_tenant_status ON integrarp.ai_ferramenta_permissao (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_conversa (
    ai_conversa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_conversa_tenant_status ON integrarp.ai_conversa (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_mensagem (
    ai_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_mensagem_tenant_status ON integrarp.ai_mensagem (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_auditoria (
    ai_auditoria_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_auditoria_tenant_status ON integrarp.ai_auditoria (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_escalonamento_humano (
    ai_escalonamento_humano_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_escalonamento_humano_tenant_status ON integrarp.ai_escalonamento_humano (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_contexto_permitido (
    ai_contexto_permitido_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_contexto_permitido_tenant_status ON integrarp.ai_contexto_permitido (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_feedback_usuario (
    ai_feedback_usuario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_feedback_usuario_tenant_status ON integrarp.ai_feedback_usuario (tenant_id, status);

CREATE TABLE IF NOT EXISTS integrarp.ai_configuracao (
    ai_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    usuario_id uuid NULL,
    tarefa_id uuid NULL,
    ai_conversa_id uuid NULL,
    tipo varchar(40) NULL,
    status varchar(40) NULL,
    descricao text NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    correlation_id varchar(120) NULL,
    origem varchar(80) NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL
);

CREATE INDEX IF NOT EXISTS ix_ai_configuracao_tenant_status ON integrarp.ai_configuracao (tenant_id, status);

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS device_id varchar(180) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS plataforma varchar(40) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS modelo varchar(120) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS app_versao varchar(40) NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS push_token text NULL;

ALTER TABLE integrarp.mobile_dispositivo ADD COLUMN IF NOT EXISTS ultimo_acesso_em timestamptz NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS pedido_id uuid NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS titulo varchar(180) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS latitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS longitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS accuracy_meters numeric(12,2) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS storage_key text NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS content_type varchar(120) NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS tamanho_bytes bigint NULL;

ALTER TABLE integrarp.mobile_evidencia ADD COLUMN IF NOT EXISTS capturado_em timestamptz NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS pedido_id uuid NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS nome_assinante varchar(180) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS documento_assinante varchar(40) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinatura_svg text NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinatura_png_storage_key text NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS latitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS longitude numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_assinatura ADD COLUMN IF NOT EXISTS assinado_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS inicio_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS fim_em timestamptz NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS latitude_inicio numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS longitude_inicio numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS latitude_fim numeric(12,8) NULL;

ALTER TABLE integrarp.mobile_execucao_tarefa ADD COLUMN IF NOT EXISTS longitude_fim numeric(12,8) NULL;

ALTER TABLE integrarp.ai_agente ADD COLUMN IF NOT EXISTS modo varchar(40) NOT NULL DEFAULT 'governado';

ALTER TABLE integrarp.ai_agente ADD COLUMN IF NOT EXISTS configuracao_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_intencao ADD COLUMN IF NOT EXISTS exemplos_json jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE integrarp.ai_intencao ADD COLUMN IF NOT EXISTS ferramenta_padrao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS modulo varchar(80) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS requer_permissao varchar(120) NULL;

ALTER TABLE integrarp.ai_ferramenta ADD COLUMN IF NOT EXISTS parametros_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS papel varchar(40) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS conteudo text NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS intencao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS ferramenta_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_mensagem ADD COLUMN IF NOT EXISTS confianca numeric(10,4) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS ai_mensagem_id uuid NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS canal varchar(40) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS pergunta text NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS intencao_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS ferramenta_codigo varchar(120) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS permissao_validada boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS escopo_validado boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS mascaramento_aplicado boolean NOT NULL DEFAULT false;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS dados_consultados_json jsonb NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS resposta text NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS confianca numeric(10,4) NULL;

ALTER TABLE integrarp.ai_auditoria ADD COLUMN IF NOT EXISTS motivo text NULL;

ALTER TABLE integrarp.ai_escalonamento_humano ADD COLUMN IF NOT EXISTS resolvido_em timestamptz NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_minha_fila AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_tarefas_atrasadas AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_mobile_dashboard AS SELECT tenant_id, tarefa_id, status, criado_em FROM integrarp.mobile_execucao_tarefa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_ai_auditoria_resumo AS SELECT tenant_id, status, ferramenta_codigo, count(*)::bigint total FROM integrarp.ai_auditoria GROUP BY tenant_id, status, ferramenta_codigo;

CREATE OR REPLACE VIEW integrarp.vw_ai_conversas_recentes AS SELECT ai_conversa_id, tenant_id, status, criado_em FROM integrarp.ai_conversa WHERE excluido_em IS NULL;

CREATE OR REPLACE VIEW integrarp.vw_ai_escalonamentos_abertos AS SELECT ai_escalonamento_humano_id, tenant_id, status, criado_em FROM integrarp.ai_escalonamento_humano WHERE status = 'aberto';

CREATE OR REPLACE FUNCTION integrarp.set_atualizado_em() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END $$;

DROP TRIGGER IF EXISTS trg_mobile_dispositivo_atualizado_em ON integrarp.mobile_dispositivo; CREATE TRIGGER trg_mobile_dispositivo_atualizado_em BEFORE UPDATE ON integrarp.mobile_dispositivo FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_sessao_atualizado_em ON integrarp.mobile_sessao; CREATE TRIGGER trg_mobile_sessao_atualizado_em BEFORE UPDATE ON integrarp.mobile_sessao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_notificacao_atualizado_em ON integrarp.mobile_notificacao; CREATE TRIGGER trg_mobile_notificacao_atualizado_em BEFORE UPDATE ON integrarp.mobile_notificacao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_anexo_atualizado_em ON integrarp.mobile_anexo; CREATE TRIGGER trg_mobile_anexo_atualizado_em BEFORE UPDATE ON integrarp.mobile_anexo FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_evidencia_atualizado_em ON integrarp.mobile_evidencia; CREATE TRIGGER trg_mobile_evidencia_atualizado_em BEFORE UPDATE ON integrarp.mobile_evidencia FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_assinatura_atualizado_em ON integrarp.mobile_assinatura; CREATE TRIGGER trg_mobile_assinatura_atualizado_em BEFORE UPDATE ON integrarp.mobile_assinatura FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_geo_evento_atualizado_em ON integrarp.mobile_geo_evento; CREATE TRIGGER trg_mobile_geo_evento_atualizado_em BEFORE UPDATE ON integrarp.mobile_geo_evento FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_sync_fila_atualizado_em ON integrarp.mobile_sync_fila; CREATE TRIGGER trg_mobile_sync_fila_atualizado_em BEFORE UPDATE ON integrarp.mobile_sync_fila FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_execucao_tarefa_atualizado_em ON integrarp.mobile_execucao_tarefa; CREATE TRIGGER trg_mobile_execucao_tarefa_atualizado_em BEFORE UPDATE ON integrarp.mobile_execucao_tarefa FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_mobile_aprovacao_atualizado_em ON integrarp.mobile_aprovacao; CREATE TRIGGER trg_mobile_aprovacao_atualizado_em BEFORE UPDATE ON integrarp.mobile_aprovacao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_agente_atualizado_em ON integrarp.ai_agente; CREATE TRIGGER trg_ai_agente_atualizado_em BEFORE UPDATE ON integrarp.ai_agente FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_intencao_atualizado_em ON integrarp.ai_intencao; CREATE TRIGGER trg_ai_intencao_atualizado_em BEFORE UPDATE ON integrarp.ai_intencao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_ferramenta_atualizado_em ON integrarp.ai_ferramenta; CREATE TRIGGER trg_ai_ferramenta_atualizado_em BEFORE UPDATE ON integrarp.ai_ferramenta FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_ferramenta_permissao_atualizado_em ON integrarp.ai_ferramenta_permissao; CREATE TRIGGER trg_ai_ferramenta_permissao_atualizado_em BEFORE UPDATE ON integrarp.ai_ferramenta_permissao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_conversa_atualizado_em ON integrarp.ai_conversa; CREATE TRIGGER trg_ai_conversa_atualizado_em BEFORE UPDATE ON integrarp.ai_conversa FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_mensagem_atualizado_em ON integrarp.ai_mensagem; CREATE TRIGGER trg_ai_mensagem_atualizado_em BEFORE UPDATE ON integrarp.ai_mensagem FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_auditoria_atualizado_em ON integrarp.ai_auditoria; CREATE TRIGGER trg_ai_auditoria_atualizado_em BEFORE UPDATE ON integrarp.ai_auditoria FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_escalonamento_humano_atualizado_em ON integrarp.ai_escalonamento_humano; CREATE TRIGGER trg_ai_escalonamento_humano_atualizado_em BEFORE UPDATE ON integrarp.ai_escalonamento_humano FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_contexto_permitido_atualizado_em ON integrarp.ai_contexto_permitido; CREATE TRIGGER trg_ai_contexto_permitido_atualizado_em BEFORE UPDATE ON integrarp.ai_contexto_permitido FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_feedback_usuario_atualizado_em ON integrarp.ai_feedback_usuario; CREATE TRIGGER trg_ai_feedback_usuario_atualizado_em BEFORE UPDATE ON integrarp.ai_feedback_usuario FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

DROP TRIGGER IF EXISTS trg_ai_configuracao_atualizado_em ON integrarp.ai_configuracao; CREATE TRIGGER trg_ai_configuracao_atualizado_em BEFORE UPDATE ON integrarp.ai_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.set_atualizado_em();

INSERT INTO integrarp.ai_agente (codigo,nome,modo,tenant_id) VALUES ('integra_assistente','Assistente IntegraRP','governado','00000000-0000-0000-0000-000000000001') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','pedido_status','pedido_status','get_order_status') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','entrega_comprovante','entrega_comprovante','get_delivery_proof') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','financeiro_titulo','financeiro_titulo','get_financial_title') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','kpi_consulta','kpi_consulta','get_authorized_kpi') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','modulo_dinamico_consulta','modulo_dinamico_consulta','search_dynamic_module') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','abrir_tarefa_humana','abrir_tarefa_humana','open_human_task') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','suporte','suporte','open_human_task') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_intencao (tenant_id,codigo,nome,ferramenta_padrao_codigo) VALUES ('00000000-0000-0000-0000-000000000001','desconhecida','desconhecida','') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_order_status','get_order_status','ai','ai.tool.order_status') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_delivery_proof','get_delivery_proof','ai','ai.tool.delivery_proof') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_financial_title','get_financial_title','ai','ai.tool.financial_title') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','search_dynamic_module','search_dynamic_module','ai','ai.tool.dynamic_module_search') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','get_authorized_kpi','get_authorized_kpi','ai','ai.tool.kpi') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.ai_ferramenta (tenant_id,codigo,nome,modulo,requer_permissao) VALUES ('00000000-0000-0000-0000-000000000001','open_human_task','open_human_task','ai','ai.tool.open_human_task') ON CONFLICT DO NOTHING;

-- <<< 0008_mobile_ai_mvp.sql

-- >>> 0009_studio_avancado_modulos_dinamicos.sql
-- Sprint 9 - Integra Studio Avancado e Modulos Dinamicos
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.modulo_dinamico (
    modulo_dinamico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    nome_plural varchar(180) NULL,
    descricao text NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    setor_dono_id uuid NULL,
    visivel_web boolean NOT NULL DEFAULT true,
    visivel_mobile boolean NOT NULL DEFAULT false,
    status varchar(40) NOT NULL DEFAULT 'rascunho',
    versao_atual int NOT NULL DEFAULT 1,
    slug varchar(140) NOT NULL,
    menu_path varchar(180) NULL,
    permite_comentarios boolean NOT NULL DEFAULT true,
    permite_anexos boolean NOT NULL DEFAULT true,
    permite_auditoria boolean NOT NULL DEFAULT true,
    permite_ia boolean NOT NULL DEFAULT false,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    publicado_em timestamptz NULL,
    publicado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_modulo_dinamico_tenant_codigo ON integrarp.modulo_dinamico (tenant_id, codigo) WHERE excluido_em IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_modulo_dinamico_tenant_slug ON integrarp.modulo_dinamico (tenant_id, slug) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.modulo_entidade (
    modulo_entidade_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, entidade_principal boolean NOT NULL DEFAULT true,
    status varchar(40) NOT NULL DEFAULT 'ativa', ordenacao_padrao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_campo (
    modulo_campo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL, modulo_entidade_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, label varchar(180) NOT NULL, tipo varchar(60) NOT NULL,
    obrigatorio boolean NOT NULL DEFAULT false, somente_leitura boolean NOT NULL DEFAULT false, visivel_listagem boolean NOT NULL DEFAULT true,
    visivel_formulario boolean NOT NULL DEFAULT true, visivel_detalhe boolean NOT NULL DEFAULT true, pesquisavel boolean NOT NULL DEFAULT false,
    mascarar boolean NOT NULL DEFAULT false, sensivel_lgpd boolean NOT NULL DEFAULT false, ordem numeric(12,4) NOT NULL DEFAULT 0,
    placeholder varchar(220) NULL, help_text text NULL, valor_padrao_json jsonb NULL, opcoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    validacao_json jsonb NOT NULL DEFAULT '{}'::jsonb, regra_visibilidade_json jsonb NOT NULL DEFAULT '{}'::jsonb, relacao_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_acao (
    modulo_acao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo_dinamico_id uuid NOT NULL,
    codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, tipo varchar(60) NOT NULL, icone varchar(80) NULL,
    cor varchar(20) NULL, exige_confirmacao boolean NOT NULL DEFAULT false, permissao_codigo varchar(160) NULL,
    regra_json jsonb NOT NULL DEFAULT '{}'::jsonb, parametros_json jsonb NOT NULL DEFAULT '{}'::jsonb, resultado_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ordem numeric(12,4) NOT NULL DEFAULT 0, ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.modulo_menu (
    modulo_menu_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_menu_tenant ON integrarp.modulo_menu (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_permissao (
    modulo_permissao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_permissao_tenant ON integrarp.modulo_permissao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_relacionamento (
    modulo_relacionamento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_relacionamento_tenant ON integrarp.modulo_relacionamento (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_kpi (
    modulo_kpi_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_kpi_tenant ON integrarp.modulo_kpi (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_bpmn_vinculo (
    modulo_bpmn_vinculo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_bpmn_vinculo_tenant ON integrarp.modulo_bpmn_vinculo (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_catalogo_semantico (
    modulo_catalogo_semantico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_catalogo_semantico_tenant ON integrarp.modulo_catalogo_semantico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_tela_configuracao (
    modulo_tela_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_tela_configuracao_tenant ON integrarp.modulo_tela_configuracao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_filtro_configuracao (
    modulo_filtro_configuracao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_filtro_configuracao_tenant ON integrarp.modulo_filtro_configuracao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_validacao (
    modulo_validacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_validacao_tenant ON integrarp.modulo_validacao (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_evento (
    modulo_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_evento_tenant ON integrarp.modulo_evento (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_template (
    modulo_template_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_template_tenant ON integrarp.modulo_template (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_publicacao_historico (
    modulo_publicacao_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_publicacao_historico_tenant ON integrarp.modulo_publicacao_historico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro (
    modulo_registro_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_tenant ON integrarp.modulo_registro (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_valor (
    modulo_registro_valor_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_valor_tenant ON integrarp.modulo_registro_valor (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_historico (
    modulo_registro_historico_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_historico_tenant ON integrarp.modulo_registro_historico (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_comentario (
    modulo_registro_comentario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_comentario_tenant ON integrarp.modulo_registro_comentario (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_anexo (
    modulo_registro_anexo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_anexo_tenant ON integrarp.modulo_registro_anexo (tenant_id);

CREATE TABLE IF NOT EXISTS integrarp.modulo_registro_acao_log (
    modulo_registro_acao_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo_dinamico_id uuid NULL,
    codigo varchar(120) NULL,
    nome varchar(180) NULL,
    tipo varchar(60) NULL,
    status varchar(40) NULL,
    dados_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid NULL,
    atualizado_em timestamptz NULL,
    atualizado_por_usuario_id uuid NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS ix_modulo_registro_acao_log_tenant ON integrarp.modulo_registro_acao_log (tenant_id);

ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS modulo_entidade_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS titulo varchar(260) NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS busca_texto text NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS setor_responsavel_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;
ALTER TABLE integrarp.modulo_registro ADD COLUMN IF NOT EXISTS tarefa_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS modulo_registro_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS modulo_campo_id uuid NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS campo_codigo varchar(120) NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_texto text NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_numero numeric(18,4) NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_data timestamptz NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_booleano boolean NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_json jsonb NULL;
ALTER TABLE integrarp.modulo_registro_valor ADD COLUMN IF NOT EXISTS valor_mascarado text NULL;

CREATE OR REPLACE VIEW integrarp.vw_studio_modulos_publicados AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, slug FROM integrarp.modulo_dinamico WHERE status = 'publicado' AND excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_registros_resumo AS SELECT tenant_id, modulo_dinamico_id, modulo_registro_id, codigo, titulo, status, criado_em FROM integrarp.modulo_registro WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_modulo_kpis AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, tipo, dados_json FROM integrarp.modulo_kpi WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_auditoria_recente AS SELECT tenant_id, modulo_dinamico_id, codigo, nome, tipo, criado_em FROM integrarp.modulo_evento WHERE excluido_em IS NULL;
CREATE OR REPLACE VIEW integrarp.vw_studio_modulos_por_setor AS SELECT tenant_id, setor_dono_id, count(*) quantidade FROM integrarp.modulo_dinamico WHERE excluido_em IS NULL GROUP BY tenant_id, setor_dono_id;

CREATE OR REPLACE FUNCTION integrarp.fn_studio_touch_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;
DROP TRIGGER IF EXISTS trg_modulo_dinamico_touch ON integrarp.modulo_dinamico;
CREATE TRIGGER trg_modulo_dinamico_touch BEFORE UPDATE ON integrarp.modulo_dinamico FOR EACH ROW EXECUTE FUNCTION integrarp.fn_studio_touch_updated_at();

INSERT INTO integrarp.modulo_template (tenant_id, codigo, nome, tipo, status, dados_json)
VALUES
('00000000-0000-0000-0000-000000000001','controle_avarias','Controle de Avarias','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','solicitacoes_internas','Solicitações Internas','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','checklist_visita','Checklist de Visita','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','pesquisa_satisfacao','Pesquisa de Satisfação','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','controle_manutencao','Controle de Manutenção','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','registro_ocorrencias','Registro de Ocorrências','template','ativo','{}'),
('00000000-0000-0000-0000-000000000001','solicitacao_compras','Solicitação de Compras','template','ativo','{}')
ON CONFLICT DO NOTHING;

-- <<< 0009_studio_avancado_modulos_dinamicos.sql

-- >>> 0010_templates_operacionais_distribuicao_campo.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.template_operacional_pacote (
    template_operacional_pacote_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    segmento varchar(120) NULL,
    versao varchar(40) NOT NULL DEFAULT '1.0',
    publico boolean NOT NULL DEFAULT true,
    ativo boolean NOT NULL DEFAULT true,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.template_operacional (
    template_operacional_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    pacote_id uuid NULL,
    tenant_id uuid NULL,
    codigo varchar(120) NOT NULL,
    nome varchar(180) NOT NULL,
    descricao text NULL,
    categoria varchar(80) NOT NULL,
    tipo varchar(60) NOT NULL,
    setor_sugerido varchar(120) NULL,
    icone varchar(80) NULL,
    cor varchar(20) NOT NULL DEFAULT '#2563EB',
    template_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.template_operacional_item (template_operacional_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, tipo varchar(60) NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_instalacao (template_operacional_instalacao_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_operacional_id uuid NULL, pacote_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', instalado_por_usuario_id uuid NULL, instalado_em timestamptz NULL, erro text NULL, objetos_criados_json jsonb NOT NULL DEFAULT '{}'::jsonb, configuracao_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_instalacao_log (template_operacional_instalacao_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, instalacao_id uuid NOT NULL, etapa varchar(120) NOT NULL, status varchar(40) NOT NULL, mensagem text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_dependencia (template_operacional_dependencia_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo_dependencia varchar(120) NOT NULL, obrigatoria boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_variavel (template_operacional_variavel_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, tipo varchar(60) NOT NULL DEFAULT 'texto', obrigatoria boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_kpi (template_operacional_kpi_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, formula_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_ai_catalogo (template_operacional_ai_catalogo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, intencao varchar(120) NOT NULL, descricao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_mensagem (template_operacional_mensagem_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, canal varchar(60) NOT NULL, conteudo text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_dashboard (template_operacional_dashboard_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, template_operacional_id uuid NOT NULL, codigo varchar(120) NOT NULL, widget_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE TABLE IF NOT EXISTS integrarp.operacao_rota (operacao_rota_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo varchar(80) NOT NULL, nome varchar(180) NOT NULL, data_rota date NOT NULL, motorista_usuario_id uuid NULL, veiculo_descricao varchar(120) NULL, status varchar(40) NOT NULL DEFAULT 'planejada', total_paradas int NOT NULL DEFAULT 0, paradas_concluidas int NOT NULL DEFAULT 0, distancia_estimativa_km numeric(18,2) NULL, inicio_em timestamptz NULL, fim_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_rota_parada (operacao_rota_parada_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, operacao_rota_id uuid NOT NULL, pedido_id uuid NULL, cliente_id uuid NULL, endereco_texto text NULL, latitude numeric(12,8) NULL, longitude numeric(12,8) NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, status varchar(40) NOT NULL DEFAULT 'pendente', previsao_inicio timestamptz NULL, previsao_fim timestamptz NULL, chegada_em timestamptz NULL, saida_em timestamptz NULL, observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_romaneio (operacao_romaneio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo varchar(80) NOT NULL, data_romaneio date NOT NULL, rota_id uuid NULL, motorista_usuario_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'rascunho', quantidade_vias int NULL, total_pedidos int NOT NULL DEFAULT 0, total_volumes int NOT NULL DEFAULT 0, observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_romaneio_item (operacao_romaneio_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, romaneio_id uuid NOT NULL, pedido_id uuid NULL, cliente_id uuid NULL, nota_fiscal_referencia_id uuid NULL, quantidade_volumes int NOT NULL DEFAULT 0, volumetria_descricao varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'pendente', ordem numeric(12,4) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_entrega_monitoramento (operacao_entrega_monitoramento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', sla_limite_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_prova_entrega (operacao_prova_entrega_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, romaneio_id uuid NULL, cliente_id uuid NULL, tarefa_id uuid NULL, tipo varchar(40) NOT NULL DEFAULT 'pod', status varchar(40) NOT NULL DEFAULT 'registrada', recebedor_nome varchar(180) NULL, recebedor_documento varchar(40) NULL, assinatura_id uuid NULL, foto_storage_key text NULL, latitude numeric(12,8) NULL, longitude numeric(12,8) NULL, entregue_em timestamptz NOT NULL DEFAULT now(), observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.operacao_ocorrencia_entrega (operacao_ocorrencia_entrega_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, rota_id uuid NULL, rota_parada_id uuid NULL, romaneio_id uuid NULL, tipo varchar(80) NOT NULL, status varchar(40) NOT NULL DEFAULT 'aberta', descricao text NOT NULL, evidencia_json jsonb NOT NULL DEFAULT '{}'::jsonb, responsavel_usuario_id uuid NULL, tarefa_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE INDEX IF NOT EXISTS ix_template_operacional_codigo ON integrarp.template_operacional (codigo);
CREATE INDEX IF NOT EXISTS ix_operacao_rota_tenant_data ON integrarp.operacao_rota (tenant_id, data_rota);
CREATE INDEX IF NOT EXISTS ix_operacao_rota_parada_rota ON integrarp.operacao_rota_parada (tenant_id, operacao_rota_id, ordem);
CREATE INDEX IF NOT EXISTS ix_operacao_romaneio_tenant_data ON integrarp.operacao_romaneio (tenant_id, data_romaneio);
CREATE INDEX IF NOT EXISTS ix_operacao_ocorrencia_status ON integrarp.operacao_ocorrencia_entrega (tenant_id, status);

CREATE OR REPLACE VIEW integrarp.vw_operacoes_dashboard AS SELECT tenant_id, count(*) AS rotas FROM integrarp.operacao_rota WHERE excluido_em IS NULL GROUP BY tenant_id;
CREATE OR REPLACE VIEW integrarp.vw_entregas_dashboard AS SELECT tenant_id, status, count(*) AS total FROM integrarp.operacao_entrega_monitoramento WHERE excluido_em IS NULL GROUP BY tenant_id, status;
CREATE OR REPLACE VIEW integrarp.vw_romaneio_dashboard AS SELECT tenant_id, status, count(*) AS total FROM integrarp.operacao_romaneio WHERE excluido_em IS NULL GROUP BY tenant_id, status;
CREATE OR REPLACE VIEW integrarp.vw_avarias_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'avarias';
CREATE OR REPLACE VIEW integrarp.vw_devolucoes_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'devolucoes';
CREATE OR REPLACE VIEW integrarp.vw_promotores_dashboard AS SELECT tenant_id, codigo, nome FROM integrarp.template_operacional WHERE categoria = 'visita_promotor';

CREATE OR REPLACE FUNCTION integrarp.fn_operacional_touch_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_operacao_rota_touch ON integrarp.operacao_rota;
CREATE TRIGGER trg_operacao_rota_touch BEFORE UPDATE ON integrarp.operacao_rota FOR EACH ROW EXECUTE FUNCTION integrarp.fn_operacional_touch_updated_at();

INSERT INTO integrarp.template_operacional_pacote (codigo, nome, descricao, segmento, versao, publico, ativo, icone, cor)
SELECT 'pacote_operacao_distribuicao', 'Pacote Operação Distribuição', 'Templates para empresas com pedidos, estoque, romaneio, entrega, devolução, avarias e equipe de campo.', 'Distribuição', '1.0', true, true, 'truck', '#2563EB'
WHERE NOT EXISTS (SELECT 1 FROM integrarp.template_operacional_pacote WHERE codigo = 'pacote_operacao_distribuicao');

INSERT INTO integrarp.template_operacional (pacote_id, codigo, nome, descricao, categoria, tipo, setor_sugerido, template_json)
SELECT p.template_operacional_pacote_id, v.codigo, v.nome, v.descricao, v.categoria, v.tipo, 'Operações', jsonb_build_object('codigo', v.codigo, 'campos', v.campos)
FROM integrarp.template_operacional_pacote p
CROSS JOIN (VALUES
    ('controle_avarias', 'Controle de Avarias', 'Controle operacional de avarias com fluxo, KPIs, IA e mobile.', 'avarias', 'modulo_dinamico', 'Cliente,Produto,Lote,Quantidade,Tipo de avaria,Foto,Descrição,Status'),
    ('tratamento_devolucoes', 'Tratamento de Devoluções', 'Tratamento de devoluções com análise comercial, logística e financeira.', 'devolucoes', 'modulo_dinamico', 'Cliente,Pedido,Produto,Nota fiscal,Motivo,Quantidade,Status'),
    ('romaneio_entrega', 'Romaneio de Entrega', 'Romaneio nativo de entrega.', 'romaneio', 'pacote', 'Pedidos,Notas fiscais,Volumetria,Motorista'),
    ('roteirizacao_entregas', 'Roteirização de Entregas', 'Roteirização sem mapas externos.', 'roteirizacao', 'pacote', 'Rota,Paradas,Motorista,Coordenadas'),
    ('monitoramento_entrega', 'Monitoramento de Entrega', 'Monitoramento, SLA, POD e ocorrências.', 'entrega', 'dashboard', 'Pendentes,Em rota,Concluídas,Ocorrências'),
    ('prova_entrega_pod', 'Prova de Entrega/POD', 'Prova de entrega com recebedor, foto, assinatura e GPS.', 'entrega', 'mobile_form', 'Recebedor,Documento,Assinatura,Foto,GPS'),
    ('visita_promotor', 'Visita de Promotor', 'Visita de promotor e checklist de gôndola.', 'visita_promotor', 'modulo_dinamico', 'PV,Promotor,GPS,Fotos,Layout,Preço'),
    ('checklist_ponto_venda', 'Checklist de Ponto de Venda', 'Checklist operacional de PDV.', 'ponto_venda', 'mobile_form', 'Layout,Precificação,Estoque,Limpeza,Promoções'),
    ('solicitacao_reposicao', 'Solicitação de Reposição', 'Solicitação de reposição com aprovação.', 'estoque_campo', 'processo_bpmn', 'Produto,PV,Quantidade,Urgência,Motivo'),
    ('pesquisa_satisfacao_pos_entrega', 'Pesquisa de Satisfação Pós-entrega', 'Pesquisa de satisfação após entrega.', 'satisfacao', 'mobile_form', 'Cliente,Pedido,Nota,Comentário,Contato')
) AS v(codigo, nome, descricao, categoria, tipo, campos)
WHERE p.codigo = 'pacote_operacao_distribuicao'
  AND NOT EXISTS (SELECT 1 FROM integrarp.template_operacional t WHERE t.codigo = v.codigo);

-- <<< 0010_templates_operacionais_distribuicao_campo.sql

-- >>> 0011_hardening_indexes_observability.sql
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.lgpd_log_acesso_dado (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    recurso text NOT NULL,
    campo text NOT NULL,
    motivo text NOT NULL,
    correlation_id text NOT NULL,
    acessado_em timestamptz NOT NULL DEFAULT now()
);

DO $$
BEGIN
    IF to_regclass('integrarp.lgpd_log_acesso_dado') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'lgpd_log_acesso_dado' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'lgpd_log_acesso_dado' AND column_name = 'acessado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_lgpd_log_acesso_dado_tenant_acessado ON integrarp.lgpd_log_acesso_dado (tenant_id, acessado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.processo_auditoria_evento') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_auditoria_evento' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_auditoria_evento' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_auditoria_tenant_criado ON integrarp.processo_auditoria_evento (tenant_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.ai_auditoria') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'ai_auditoria' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'ai_auditoria' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_ai_auditoria_tenant_criado ON integrarp.ai_auditoria (tenant_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.tarefa') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'responsavel_usuario_id') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_status_responsavel ON integrarp.tarefa (tenant_id, status, responsavel_usuario_id)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.tarefa') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'prazo_em') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa' AND column_name = 'prioridade') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_tarefa_tenant_prazo_prioridade ON integrarp.tarefa (tenant_id, prazo_em, prioridade)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.processo_instancia') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'processo_instancia' AND column_name = 'atualizado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_processo_instancia_tenant_status_atualizado ON integrarp.processo_instancia (tenant_id, status, atualizado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.modulo_registro') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'modulo_dinamico_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'modulo_registro' AND column_name = 'atualizado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_modulo_registro_tenant_modulo_atualizado ON integrarp.modulo_registro (tenant_id, modulo_dinamico_id, atualizado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.pedido') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'pedido' AND column_name = 'cliente_id') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_pedido_tenant_status_cliente ON integrarp.pedido (tenant_id, status, cliente_id)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.estoque_lote') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'produto_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'estoque_lote' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_estoque_lote_tenant_produto_criado ON integrarp.estoque_lote (tenant_id, produto_id, criado_em DESC)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.outbox_evento') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'status') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'outbox_evento' AND column_name = 'criado_em') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_criado ON integrarp.outbox_evento (tenant_id, status, criado_em)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.projeto_central_item') IS NOT NULL AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'tenant_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'board_id') AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'projeto_central_item' AND column_name = 'status') THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS ix_projeto_central_item_tenant_board_status ON integrarp.projeto_central_item (tenant_id, board_id, status)';
    END IF;
END $$;

-- <<< 0011_hardening_indexes_observability.sql

-- >>> 0012_piloto_v1_final_adjustments.sql
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE TABLE IF NOT EXISTS integrarp.piloto_v1_demo_catalogo (
    id UUID PRIMARY KEY,
    categoria TEXT NOT NULL,
    chave TEXT NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'ativo',
    tenant_demo TEXT NOT NULL DEFAULT 'Valora Group & MNSoft Demo',
    metadados JSONB NOT NULL DEFAULT '{}'::jsonb,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_piloto_v1_demo_catalogo UNIQUE (categoria, chave)
);

CREATE INDEX IF NOT EXISTS ix_piloto_v1_demo_catalogo_categoria
    ON integrarp.piloto_v1_demo_catalogo (categoria);

CREATE INDEX IF NOT EXISTS ix_piloto_v1_demo_catalogo_status
    ON integrarp.piloto_v1_demo_catalogo (status);

INSERT INTO integrarp.piloto_v1_demo_catalogo (id, categoria, chave, nome, descricao, status, metadados)
VALUES
    ('00000000-0012-0000-0000-000000000001', 'tenant', 'valora-mnsoft-demo', 'Valora Group & MNSoft Demo', 'Tenant demonstrativo do piloto v1.0.', 'ativo', '{"ambiente":"piloto","senha_demo":"Integr@RP-Piloto-2026!"}'),
    ('00000000-0012-0000-0000-000000000002', 'usuario', 'admin@integrarp.local', 'Administrador Geral', 'Conta demo para administração geral.', 'ativo', '{"perfil":"Administrador Geral"}'),
    ('00000000-0012-0000-0000-000000000003', 'usuario', 'diretor@integrarp.local', 'Diretor', 'Conta demo para visão executiva.', 'ativo', '{"perfil":"Diretor"}'),
    ('00000000-0012-0000-0000-000000000004', 'usuario', 'financeiro@integrarp.local', 'Financeiro', 'Conta demo para faturamento, títulos e boletos fake/log.', 'ativo', '{"perfil":"Financeiro"}'),
    ('00000000-0012-0000-0000-000000000005', 'usuario', 'vendas@integrarp.local', 'Vendas', 'Conta demo para cliente, produto e pedido.', 'ativo', '{"perfil":"Vendas"}'),
    ('00000000-0012-0000-0000-000000000006', 'usuario', 'logistica@integrarp.local', 'Logística', 'Conta demo para estoque, rotas e romaneios.', 'ativo', '{"perfil":"Logística"}'),
    ('00000000-0012-0000-0000-000000000007', 'usuario', 'motorista@integrarp.local', 'Motorista', 'Conta demo para POD, GPS, assinatura e ocorrências.', 'ativo', '{"perfil":"Motorista"}'),
    ('00000000-0012-0000-0000-000000000008', 'usuario', 'promotor@integrarp.local', 'Promotor de Vendas', 'Conta demo para execução em campo.', 'ativo', '{"perfil":"Promotor de Vendas"}'),
    ('00000000-0012-0000-0000-000000000009', 'usuario', 'auditor@integrarp.local', 'Auditor / LGPD', 'Conta demo para auditoria, LGPD e IA governada.', 'ativo', '{"perfil":"Auditor / LGPD"}'),
    ('00000000-0012-0000-0000-000000000010', 'cliente', 'cliente-alfa', 'Cliente Alfa Distribuição', 'Cliente demo com pedido confirmado e faturado.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000011', 'produto', 'sku-cafe-premium', 'Café Premium 500g', 'Produto demo com entrada, lote e reserva de estoque.', 'ativo', '{"sku":"CAF-PREM-500"}'),
    ('00000000-0012-0000-0000-000000000012', 'pedido', 'pedido-pos-venda', 'Pedido ao Pós-venda', 'Cenário ponta a ponta de pedido, faturamento, entrega e auditoria.', 'em_fluxo', '{"flow":"Pedido ao Pós-venda"}'),
    ('00000000-0012-0000-0000-000000000013', 'financeiro', 'boleto-fake-demo', 'Boleto fake demo', 'Título e boleto fake/log para homologação sem integração bancária real.', 'processado', '{"provider":"fake/log"}'),
    ('00000000-0012-0000-0000-000000000014', 'connect', 'outbox-pendente-demo', 'Outbox pendente demo', 'Mensagem pendente para validação do worker.', 'pendente', '{}'),
    ('00000000-0012-0000-0000-000000000015', 'connect', 'outbox-processado-demo', 'Outbox processado demo', 'Mensagem processada para histórico de conectividade.', 'processado', '{}'),
    ('00000000-0012-0000-0000-000000000016', 'flow', 'processo-pedido-pos-venda', 'Processo Pedido ao Pós-venda', 'Processo BPMN publicado para o piloto.', 'publicado', '{}'),
    ('00000000-0012-0000-0000-000000000017', 'studio', 'controle-avarias', 'Controle de Avarias', 'Módulo dinâmico publicado com registros demo.', 'publicado', '{}'),
    ('00000000-0012-0000-0000-000000000018', 'project', 'board-piloto-v1', 'Board Project Demo', 'Board com sprint, cards e feed de homologação.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000019', 'operacoes', 'rota-romaneio-pod-demo', 'Rota, Romaneio e POD Demo', 'Rota demo com paradas, ocorrência e comprovante de entrega.', 'ativo', '{}'),
    ('00000000-0012-0000-0000-000000000020', 'ia', 'conversa-governada-demo', 'Conversa IA Governada Demo', 'Perguntas autorizadas, fallback humano e auditoria da IA.', 'auditado', '{}')
ON CONFLICT (categoria, chave) DO UPDATE
SET nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    status = EXCLUDED.status,
    metadados = EXCLUDED.metadados,
    atualizado_em = now();

CREATE OR REPLACE VIEW integrarp.vw_piloto_validacao_fluxos AS
SELECT categoria, chave, nome, status
FROM integrarp.piloto_v1_demo_catalogo
WHERE categoria IN ('flow', 'studio', 'pedido', 'financeiro', 'connect', 'project', 'operacoes', 'ia');

CREATE OR REPLACE VIEW integrarp.vw_piloto_saude_operacional AS
SELECT status, count(*) AS total
FROM integrarp.piloto_v1_demo_catalogo
GROUP BY status;

CREATE OR REPLACE VIEW integrarp.vw_piloto_dados_demo AS
SELECT categoria, count(*) AS total
FROM integrarp.piloto_v1_demo_catalogo
GROUP BY categoria;

CREATE OR REPLACE VIEW integrarp.vw_piloto_pendencias AS
SELECT categoria, chave, nome, descricao
FROM integrarp.piloto_v1_demo_catalogo
WHERE status IN ('pendente', 'em_fluxo');

-- <<< 0012_piloto_v1_final_adjustments.sql

-- >>> 0013_v11_scriptcompleto_forms_automation.sql
-- IntegraRP database complete idempotent script v1.1
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Core
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Segurança
CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, email text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Flow
CREATE TABLE IF NOT EXISTS integrarp.flow_tarefa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, titulo text NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Studio
CREATE TABLE IF NOT EXISTS integrarp.studio_modulo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Comercial
CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero text NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Estoque
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, sku text NOT NULL, nome text NOT NULL, estoque_atual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Faturamento
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, numero text NOT NULL, valor numeric NOT NULL, vencimento date NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Connect
CREATE TABLE IF NOT EXISTS integrarp.connect_outbox (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- BI
CREATE TABLE IF NOT EXISTS integrarp.kpi_valor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, valor numeric NOT NULL, referencia_em timestamptz NOT NULL DEFAULT now(), criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Project
CREATE TABLE IF NOT EXISTS integrarp.project_board (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Mobile
CREATE TABLE IF NOT EXISTS integrarp.mobile_device (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, push_token text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- IA
CREATE TABLE IF NOT EXISTS integrarp.ai_auditoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pergunta text NOT NULL, resposta text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
-- Operações
CREATE TABLE IF NOT EXISTS integrarp.entrega (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, status text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Forms
CREATE TABLE IF NOT EXISTS integrarp.formulario_definicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, descricao text NULL, status text NOT NULL DEFAULT 'draft', versao_publicada_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_versao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_definicao_id uuid NOT NULL, numero int NOT NULL, publicado boolean NOT NULL DEFAULT false, publicado_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_secao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, titulo text NOT NULL, ordem int NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_campo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_secao_id uuid NOT NULL, chave text NOT NULL, rotulo text NOT NULL, tipo text NOT NULL, ordem int NOT NULL, obrigatorio boolean NOT NULL DEFAULT false, mascara text NULL, regex_validacao text NULL, valor_padrao text NULL, opcoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, visibilidade_json jsonb NOT NULL DEFAULT '{}'::jsonb, calculo_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_regra (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, nome text NOT NULL, condicao_json jsonb NOT NULL, acao_json jsonb NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_resposta (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_versao_id uuid NOT NULL, entidade_tipo text NULL, entidade_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_resposta_campo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_resposta_id uuid NOT NULL, formulario_campo_id uuid NOT NULL, valor_json jsonb NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_template (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, template_json jsonb NOT NULL, demo boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.formulario_validacao_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, formulario_resposta_id uuid NULL, mensagem text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Automação
CREATE TABLE IF NOT EXISTS integrarp.automacao_regra (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, habilitada boolean NOT NULL DEFAULT true, max_retries int NOT NULL DEFAULT 3, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_gatilho (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, tipo text NOT NULL, config_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_condicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, campo text NOT NULL, operador text NOT NULL, valor_esperado text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_acao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, tipo text NOT NULL, ordem int NOT NULL, config_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_execucao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_regra_id uuid NOT NULL, status text NOT NULL DEFAULT 'pendente', tentativa int NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.automacao_execucao_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, automacao_execucao_id uuid NOT NULL, nivel text NOT NULL, mensagem text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Anexos
CREATE TABLE IF NOT EXISTS integrarp.anexo_arquivo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome_arquivo text NOT NULL, content_type text NOT NULL, tamanho_bytes bigint NOT NULL, extensao text NOT NULL, sha256 text NOT NULL, storage_key text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_vinculo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, entidade_tipo text NOT NULL, entidade_id uuid NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_versao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, numero int NOT NULL, storage_key text NOT NULL, sha256 text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_auditoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, acao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_thumbnail (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, storage_key text NOT NULL, largura int NOT NULL, altura int NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_assinatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, anexo_arquivo_id uuid NOT NULL, assinante text NOT NULL, assinado_em timestamptz NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.anexo_configuracao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, extensoes_permitidas text NOT NULL, tamanho_maximo_bytes bigint NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Notificações
CREATE TABLE IF NOT EXISTS integrarp.notificacao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, evento text NOT NULL, titulo text NOT NULL, corpo text NOT NULL, canal text NOT NULL DEFAULT 'sistema', status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_destinatario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, notificacao_id uuid NOT NULL, usuario_id uuid NOT NULL, lida boolean NOT NULL DEFAULT false, lida_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_preferencia (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, canal text NOT NULL, habilitado boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_template (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, evento text NOT NULL, canal text NOT NULL, assunto_template text NOT NULL, corpo_template text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.notificacao_push_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, notificacao_id uuid NOT NULL, canal text NOT NULL, status text NOT NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

-- Relatórios
CREATE TABLE IF NOT EXISTS integrarp.relatorio_definicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, chave_consulta text NOT NULL, formatos_json jsonb NOT NULL DEFAULT '["csv","pdf_html","json"]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_filtro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, nome text NOT NULL, tipo text NOT NULL, obrigatorio boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_execucao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, status text NOT NULL DEFAULT 'pendente', parametros_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_exportacao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_execucao_id uuid NOT NULL, formato text NOT NULL, storage_key text NOT NULL, expira_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.relatorio_agendamento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, relatorio_definicao_id uuid NOT NULL, cron text NOT NULL, formato text NOT NULL, habilitado boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

ALTER TABLE integrarp.formulario_definicao ADD COLUMN IF NOT EXISTS categoria text NULL;
ALTER TABLE integrarp.automacao_regra ADD COLUMN IF NOT EXISTS seguranca_json jsonb NOT NULL DEFAULT '{"no_eval":true,"no_dynamic_sql":true,"rbac":true}'::jsonb;
ALTER TABLE integrarp.anexo_arquivo ADD COLUMN IF NOT EXISTS validado boolean NOT NULL DEFAULT true;
ALTER TABLE integrarp.relatorio_definicao ADD COLUMN IF NOT EXISTS descricao text NULL;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_formulario_campo_tipo_v11') THEN ALTER TABLE integrarp.formulario_campo ADD CONSTRAINT ck_formulario_campo_tipo_v11 CHECK (tipo IN ('text','textarea','number','money','date','datetime','boolean','select','multiselect','user','sector','client','product','order','financial_title','dynamic_record','file','photo','signature','gps','barcode','qrcode','rating','checklist','json','relation')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_notificacao_canal_v11') THEN ALTER TABLE integrarp.notificacao ADD CONSTRAINT ck_notificacao_canal_v11 CHECK (canal IN ('sistema','email_fake','whatsapp_fake','telegram_fake','mobile_push_fake','webhook_fake')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_relatorio_formato_v11') THEN ALTER TABLE integrarp.relatorio_exportacao ADD CONSTRAINT ck_relatorio_formato_v11 CHECK (formato IN ('csv','xlsx','pdf_html','json')); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_formulario_definicao_tenant ON integrarp.formulario_definicao(tenant_id);
CREATE INDEX IF NOT EXISTS ix_automacao_execucao_status ON integrarp.automacao_execucao(tenant_id,status);
CREATE INDEX IF NOT EXISTS ix_anexo_vinculo_entidade ON integrarp.anexo_vinculo(tenant_id,entidade_tipo,entidade_id);
CREATE INDEX IF NOT EXISTS ix_notificacao_destinatario_usuario ON integrarp.notificacao_destinatario(tenant_id,usuario_id,lida);
CREATE INDEX IF NOT EXISTS ix_relatorio_execucao_relatorio ON integrarp.relatorio_execucao(tenant_id,relatorio_definicao_id,status);

CREATE OR REPLACE VIEW integrarp.vw_v11_relatorios_demo AS SELECT tenant_id, nome, chave_consulta FROM integrarp.relatorio_definicao WHERE excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_formulario_definicao_atualizado_em ON integrarp.formulario_definicao;
CREATE TRIGGER trg_formulario_definicao_atualizado_em BEFORE UPDATE ON integrarp.formulario_definicao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_automacao_regra_atualizado_em ON integrarp.automacao_regra;
CREATE TRIGGER trg_automacao_regra_atualizado_em BEFORE UPDATE ON integrarp.automacao_regra FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_anexo_arquivo_atualizado_em ON integrarp.anexo_arquivo;
CREATE TRIGGER trg_anexo_arquivo_atualizado_em BEFORE UPDATE ON integrarp.anexo_arquivo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_notificacao_atualizado_em ON integrarp.notificacao;
CREATE TRIGGER trg_notificacao_atualizado_em BEFORE UPDATE ON integrarp.notificacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_relatorio_definicao_atualizado_em ON integrarp.relatorio_definicao;
CREATE TRIGGER trg_relatorio_definicao_atualizado_em BEFORE UPDATE ON integrarp.relatorio_definicao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.tenant (id,nome,metadata_json) VALUES ('11111111-1111-1111-1111-111111111111','Demo IntegraRP v1.1','{"demo":true}'::jsonb) ON CONFLICT (id) DO NOTHING;
INSERT INTO integrarp.formulario_template (tenant_id,nome,template_json,demo) VALUES
('11111111-1111-1111-1111-111111111111','Checklist de Visita Comercial','{"fields":["cliente","gps","assinatura"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Checklist de Entrega com POD','{"fields":["photo","signature","gps"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Registro de Avaria','{"fields":["product","photo","textarea"]}'::jsonb,true),
('11111111-1111-1111-1111-111111111111','Pesquisa de Satisfação','{"fields":["rating","textarea"]}'::jsonb,true)
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.automacao_regra (tenant_id,nome,habilitada,metadata_json) VALUES
('11111111-1111-1111-1111-111111111111','Tarefa atrasada',true,'{"trigger":"task_overdue","action":"send_notification"}'::jsonb),
('11111111-1111-1111-1111-111111111111','Ocorrência cria tarefa',true,'{"trigger":"delivery_occurrence_created","action":"create_task"}'::jsonb)
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.relatorio_definicao (tenant_id,nome,chave_consulta) VALUES
('11111111-1111-1111-1111-111111111111','Pedidos por período','orders_by_period'),
('11111111-1111-1111-1111-111111111111','Estoque crítico','critical_inventory'),
('11111111-1111-1111-1111-111111111111','Títulos vencidos','overdue_titles')
ON CONFLICT DO NOTHING;
INSERT INTO integrarp.notificacao (tenant_id,evento,titulo,corpo,canal,status) VALUES ('11111111-1111-1111-1111-111111111111','automacao falhou','Demo v1.1','Notificação demo','sistema','pendente') ON CONFLICT DO NOTHING;
INSERT INTO integrarp.anexo_configuracao (tenant_id,extensoes_permitidas,tamanho_maximo_bytes,metadata_json) VALUES ('11111111-1111-1111-1111-111111111111','.pdf,.png,.jpg,.jpeg,.csv',10485760,'{"demo":"Anexos demo"}'::jsonb) ON CONFLICT DO NOTHING;
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- <<< 0013_v11_scriptcompleto_forms_automation.sql

-- >>> 0014_v12_integracoes_fiscal_conciliacao_rotas_offline.sql
CREATE SCHEMA IF NOT EXISTS integrarp;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em() RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_tenant_status ON integrarp.integracao_conector (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector ADD CONSTRAINT ck_integracao_conector_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_atualizado_em ON integrarp.integracao_conector; CREATE TRIGGER trg_integracao_conector_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_conector_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_conector_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_conector_configuracao_tenant_status ON integrarp.integracao_conector_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_conector_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_conector_configuracao ADD CONSTRAINT ck_integracao_conector_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_conector_configuracao_atualizado_em ON integrarp.integracao_conector_configuracao; CREATE TRIGGER trg_integracao_conector_configuracao_atualizado_em BEFORE UPDATE ON integrarp.integracao_conector_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_credencial_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_credencial_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_credencial_referencia_tenant_status ON integrarp.integracao_credencial_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_credencial_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_credencial_referencia ADD CONSTRAINT ck_integracao_credencial_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_credencial_referencia_atualizado_em ON integrarp.integracao_credencial_referencia; CREATE TRIGGER trg_integracao_credencial_referencia_atualizado_em BEFORE UPDATE ON integrarp.integracao_credencial_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_tenant_status ON integrarp.integracao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao ADD CONSTRAINT ck_integracao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_atualizado_em ON integrarp.integracao_execucao; CREATE TRIGGER trg_integracao_execucao_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_execucao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_execucao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_execucao_log_tenant_status ON integrarp.integracao_execucao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_execucao_log_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_execucao_log ADD CONSTRAINT ck_integracao_execucao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_execucao_log_atualizado_em ON integrarp.integracao_execucao_log; CREATE TRIGGER trg_integracao_execucao_log_atualizado_em BEFORE UPDATE ON integrarp.integracao_execucao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_endpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_endpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_endpoint_tenant_status ON integrarp.integracao_webhook_endpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_endpoint_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_endpoint ADD CONSTRAINT ck_integracao_webhook_endpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_endpoint_atualizado_em ON integrarp.integracao_webhook_endpoint; CREATE TRIGGER trg_integracao_webhook_endpoint_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_endpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_webhook_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_webhook_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_webhook_evento_tenant_status ON integrarp.integracao_webhook_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_webhook_evento_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_webhook_evento ADD CONSTRAINT ck_integracao_webhook_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_webhook_evento_atualizado_em ON integrarp.integracao_webhook_evento; CREATE TRIGGER trg_integracao_webhook_evento_atualizado_em BEFORE UPDATE ON integrarp.integracao_webhook_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_mapeamento_campo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_mapeamento_campo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_mapeamento_campo_tenant_status ON integrarp.integracao_mapeamento_campo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_mapeamento_campo_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_mapeamento_campo ADD CONSTRAINT ck_integracao_mapeamento_campo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_mapeamento_campo_atualizado_em ON integrarp.integracao_mapeamento_campo; CREATE TRIGGER trg_integracao_mapeamento_campo_atualizado_em BEFORE UPDATE ON integrarp.integracao_mapeamento_campo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_saida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_saida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_saida_tenant_status ON integrarp.integracao_fila_saida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_saida_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_saida ADD CONSTRAINT ck_integracao_fila_saida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_saida_atualizado_em ON integrarp.integracao_fila_saida; CREATE TRIGGER trg_integracao_fila_saida_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_saida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.integracao_fila_entrada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.integracao_fila_entrada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_integracao_fila_entrada_tenant_status ON integrarp.integracao_fila_entrada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_integracao_fila_entrada_tenant_not_empty') THEN ALTER TABLE integrarp.integracao_fila_entrada ADD CONSTRAINT ck_integracao_fila_entrada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_integracao_fila_entrada_atualizado_em ON integrarp.integracao_fila_entrada; CREATE TRIGGER trg_integracao_fila_entrada_atualizado_em BEFORE UPDATE ON integrarp.integracao_fila_entrada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_configuracao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_configuracao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_configuracao_tenant_status ON integrarp.fiscal_configuracao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_configuracao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_configuracao ADD CONSTRAINT ck_fiscal_configuracao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_configuracao_atualizado_em ON integrarp.fiscal_configuracao; CREATE TRIGGER trg_fiscal_configuracao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_configuracao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    xml_fake text,
    danfe_html_fake text,
    pedido_id uuid,
    fatura_id uuid,
    cliente_id uuid
);

ALTER TABLE integrarp.fiscal_documento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_tenant_status ON integrarp.fiscal_documento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento ADD CONSTRAINT ck_fiscal_documento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_atualizado_em ON integrarp.fiscal_documento; CREATE TRIGGER trg_fiscal_documento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_item_tenant_status ON integrarp.fiscal_documento_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_item_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_item ADD CONSTRAINT ck_fiscal_documento_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_item_atualizado_em ON integrarp.fiscal_documento_item; CREATE TRIGGER trg_fiscal_documento_item_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_documento_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_documento_evento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_documento_evento_tenant_status ON integrarp.fiscal_documento_evento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_documento_evento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_documento_evento ADD CONSTRAINT ck_fiscal_documento_evento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_documento_evento_atualizado_em ON integrarp.fiscal_documento_evento; CREATE TRIGGER trg_fiscal_documento_evento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_documento_evento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_lote (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_lote ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_lote_tenant_status ON integrarp.fiscal_emissao_lote (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_lote_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_lote ADD CONSTRAINT ck_fiscal_emissao_lote_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_lote_atualizado_em ON integrarp.fiscal_emissao_lote; CREATE TRIGGER trg_fiscal_emissao_lote_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_lote FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_emissao_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_emissao_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_emissao_log_tenant_status ON integrarp.fiscal_emissao_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_emissao_log_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_emissao_log ADD CONSTRAINT ck_fiscal_emissao_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_emissao_log_atualizado_em ON integrarp.fiscal_emissao_log; CREATE TRIGGER trg_fiscal_emissao_log_atualizado_em BEFORE UPDATE ON integrarp.fiscal_emissao_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_cancelamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_cancelamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_cancelamento_tenant_status ON integrarp.fiscal_cancelamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_cancelamento_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_cancelamento ADD CONSTRAINT ck_fiscal_cancelamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_cancelamento_atualizado_em ON integrarp.fiscal_cancelamento; CREATE TRIGGER trg_fiscal_cancelamento_atualizado_em BEFORE UPDATE ON integrarp.fiscal_cancelamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_carta_correcao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_carta_correcao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_carta_correcao_tenant_status ON integrarp.fiscal_carta_correcao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_carta_correcao_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_carta_correcao ADD CONSTRAINT ck_fiscal_carta_correcao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_carta_correcao_atualizado_em ON integrarp.fiscal_carta_correcao; CREATE TRIGGER trg_fiscal_carta_correcao_atualizado_em BEFORE UPDATE ON integrarp.fiscal_carta_correcao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_serie (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_serie ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_serie_tenant_status ON integrarp.fiscal_serie (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_serie_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_serie ADD CONSTRAINT ck_fiscal_serie_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_serie_atualizado_em ON integrarp.fiscal_serie; CREATE TRIGGER trg_fiscal_serie_atualizado_em BEFORE UPDATE ON integrarp.fiscal_serie FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_certificado_referencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_certificado_referencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_certificado_referencia_tenant_status ON integrarp.fiscal_certificado_referencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_certificado_referencia_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_certificado_referencia ADD CONSTRAINT ck_fiscal_certificado_referencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_certificado_referencia_atualizado_em ON integrarp.fiscal_certificado_referencia; CREATE TRIGGER trg_fiscal_certificado_referencia_atualizado_em BEFORE UPDATE ON integrarp.fiscal_certificado_referencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.fiscal_provedor (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.fiscal_provedor ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_fiscal_provedor_tenant_status ON integrarp.fiscal_provedor (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_fiscal_provedor_tenant_not_empty') THEN ALTER TABLE integrarp.fiscal_provedor ADD CONSTRAINT ck_fiscal_provedor_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_fiscal_provedor_atualizado_em ON integrarp.fiscal_provedor; CREATE TRIGGER trg_fiscal_provedor_atualizado_em BEFORE UPDATE ON integrarp.fiscal_provedor FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conta_bancaria (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conta_bancaria ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conta_bancaria_tenant_status ON integrarp.financeiro_conta_bancaria (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conta_bancaria_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conta_bancaria ADD CONSTRAINT ck_financeiro_conta_bancaria_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conta_bancaria_atualizado_em ON integrarp.financeiro_conta_bancaria; CREATE TRIGGER trg_financeiro_conta_bancaria_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conta_bancaria FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_importacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_importacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_importacao_tenant_status ON integrarp.financeiro_extrato_importacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_importacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_importacao ADD CONSTRAINT ck_financeiro_extrato_importacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_importacao_atualizado_em ON integrarp.financeiro_extrato_importacao; CREATE TRIGGER trg_financeiro_extrato_importacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_importacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_extrato_lancamento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_extrato_lancamento ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_extrato_lancamento_tenant_status ON integrarp.financeiro_extrato_lancamento (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_extrato_lancamento_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_extrato_lancamento ADD CONSTRAINT ck_financeiro_extrato_lancamento_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_extrato_lancamento_atualizado_em ON integrarp.financeiro_extrato_lancamento; CREATE TRIGGER trg_financeiro_extrato_lancamento_atualizado_em BEFORE UPDATE ON integrarp.financeiro_extrato_lancamento FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_tenant_status ON integrarp.financeiro_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao ADD CONSTRAINT ck_financeiro_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_atualizado_em ON integrarp.financeiro_conciliacao; CREATE TRIGGER trg_financeiro_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_conciliacao_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_conciliacao_item ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_conciliacao_item_tenant_status ON integrarp.financeiro_conciliacao_item (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_conciliacao_item_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_conciliacao_item ADD CONSTRAINT ck_financeiro_conciliacao_item_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_conciliacao_item_atualizado_em ON integrarp.financeiro_conciliacao_item; CREATE TRIGGER trg_financeiro_conciliacao_item_atualizado_em BEFORE UPDATE ON integrarp.financeiro_conciliacao_item FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_baixa_sugerida (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_baixa_sugerida ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_baixa_sugerida_tenant_status ON integrarp.financeiro_baixa_sugerida (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_baixa_sugerida_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_baixa_sugerida ADD CONSTRAINT ck_financeiro_baixa_sugerida_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_baixa_sugerida_atualizado_em ON integrarp.financeiro_baixa_sugerida; CREATE TRIGGER trg_financeiro_baixa_sugerida_atualizado_em BEFORE UPDATE ON integrarp.financeiro_baixa_sugerida FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_regra_conciliacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_regra_conciliacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_regra_conciliacao_tenant_status ON integrarp.financeiro_regra_conciliacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_regra_conciliacao_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_regra_conciliacao ADD CONSTRAINT ck_financeiro_regra_conciliacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_regra_conciliacao_atualizado_em ON integrarp.financeiro_regra_conciliacao; CREATE TRIGGER trg_financeiro_regra_conciliacao_atualizado_em BEFORE UPDATE ON integrarp.financeiro_regra_conciliacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_alerta_inadimplencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_alerta_inadimplencia_tenant_status ON integrarp.financeiro_alerta_inadimplencia (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_alerta_inadimplencia_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_alerta_inadimplencia ADD CONSTRAINT ck_financeiro_alerta_inadimplencia_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_alerta_inadimplencia_atualizado_em ON integrarp.financeiro_alerta_inadimplencia; CREATE TRIGGER trg_financeiro_alerta_inadimplencia_atualizado_em BEFORE UPDATE ON integrarp.financeiro_alerta_inadimplencia FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.financeiro_projecao_recebivel (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.financeiro_projecao_recebivel ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_financeiro_projecao_recebivel_tenant_status ON integrarp.financeiro_projecao_recebivel (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_financeiro_projecao_recebivel_tenant_not_empty') THEN ALTER TABLE integrarp.financeiro_projecao_recebivel ADD CONSTRAINT ck_financeiro_projecao_recebivel_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_financeiro_projecao_recebivel_atualizado_em ON integrarp.financeiro_projecao_recebivel; CREATE TRIGGER trg_financeiro_projecao_recebivel_atualizado_em BEFORE UPDATE ON integrarp.financeiro_projecao_recebivel FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_execucao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_execucao_tenant_status ON integrarp.rota_otimizacao_execucao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_execucao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_execucao ADD CONSTRAINT ck_rota_otimizacao_execucao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_execucao_atualizado_em ON integrarp.rota_otimizacao_execucao; CREATE TRIGGER trg_rota_otimizacao_execucao_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_parada (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz,
    latitude numeric(10,7), longitude numeric(10,7), ordem_original integer, ordem_sugerida integer
);

ALTER TABLE integrarp.rota_otimizacao_parada ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_parada_tenant_status ON integrarp.rota_otimizacao_parada (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_parada_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_parada ADD CONSTRAINT ck_rota_otimizacao_parada_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_parada_atualizado_em ON integrarp.rota_otimizacao_parada; CREATE TRIGGER trg_rota_otimizacao_parada_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_parada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_otimizacao_resultado (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_otimizacao_resultado ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_otimizacao_resultado_tenant_status ON integrarp.rota_otimizacao_resultado (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_otimizacao_resultado_tenant_not_empty') THEN ALTER TABLE integrarp.rota_otimizacao_resultado ADD CONSTRAINT ck_rota_otimizacao_resultado_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_otimizacao_resultado_atualizado_em ON integrarp.rota_otimizacao_resultado; CREATE TRIGGER trg_rota_otimizacao_resultado_atualizado_em BEFORE UPDATE ON integrarp.rota_otimizacao_resultado FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_distancia_cache (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_distancia_cache ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_distancia_cache_tenant_status ON integrarp.rota_distancia_cache (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_distancia_cache_tenant_not_empty') THEN ALTER TABLE integrarp.rota_distancia_cache ADD CONSTRAINT ck_rota_distancia_cache_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_distancia_cache_atualizado_em ON integrarp.rota_distancia_cache; CREATE TRIGGER trg_rota_distancia_cache_atualizado_em BEFORE UPDATE ON integrarp.rota_distancia_cache FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_regra_otimizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_regra_otimizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_regra_otimizacao_tenant_status ON integrarp.rota_regra_otimizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_regra_otimizacao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_regra_otimizacao ADD CONSTRAINT ck_rota_regra_otimizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_regra_otimizacao_atualizado_em ON integrarp.rota_regra_otimizacao; CREATE TRIGGER trg_rota_regra_otimizacao_atualizado_em BEFORE UPDATE ON integrarp.rota_regra_otimizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_restricao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_restricao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_restricao_tenant_status ON integrarp.rota_restricao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_restricao_tenant_not_empty') THEN ALTER TABLE integrarp.rota_restricao ADD CONSTRAINT ck_rota_restricao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_restricao_atualizado_em ON integrarp.rota_restricao; CREATE TRIGGER trg_rota_restricao_atualizado_em BEFORE UPDATE ON integrarp.rota_restricao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.rota_janela_entrega (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.rota_janela_entrega ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_rota_janela_entrega_tenant_status ON integrarp.rota_janela_entrega (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_rota_janela_entrega_tenant_not_empty') THEN ALTER TABLE integrarp.rota_janela_entrega ADD CONSTRAINT ck_rota_janela_entrega_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_rota_janela_entrega_atualizado_em ON integrarp.rota_janela_entrega; CREATE TRIGGER trg_rota_janela_entrega_atualizado_em BEFORE UPDATE ON integrarp.rota_janela_entrega FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_dispositivo (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_dispositivo ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_dispositivo_tenant_status ON integrarp.offline_dispositivo (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_dispositivo_tenant_not_empty') THEN ALTER TABLE integrarp.offline_dispositivo ADD CONSTRAINT ck_offline_dispositivo_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_dispositivo_atualizado_em ON integrarp.offline_dispositivo; CREATE TRIGGER trg_offline_dispositivo_atualizado_em BEFORE UPDATE ON integrarp.offline_dispositivo FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_pacote_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_pacote_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_pacote_sincronizacao_tenant_status ON integrarp.offline_pacote_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_pacote_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_pacote_sincronizacao ADD CONSTRAINT ck_offline_pacote_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_pacote_sincronizacao_atualizado_em ON integrarp.offline_pacote_sincronizacao; CREATE TRIGGER trg_offline_pacote_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_pacote_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_item_sincronizacao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_item_sincronizacao ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_item_sincronizacao_tenant_status ON integrarp.offline_item_sincronizacao (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_item_sincronizacao_tenant_not_empty') THEN ALTER TABLE integrarp.offline_item_sincronizacao ADD CONSTRAINT ck_offline_item_sincronizacao_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_item_sincronizacao_atualizado_em ON integrarp.offline_item_sincronizacao; CREATE TRIGGER trg_offline_item_sincronizacao_atualizado_em BEFORE UPDATE ON integrarp.offline_item_sincronizacao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_conflito_tenant_status ON integrarp.offline_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_conflito ADD CONSTRAINT ck_offline_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_conflito_atualizado_em ON integrarp.offline_conflito; CREATE TRIGGER trg_offline_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_resolucao_conflito (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_resolucao_conflito ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_resolucao_conflito_tenant_status ON integrarp.offline_resolucao_conflito (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_resolucao_conflito_tenant_not_empty') THEN ALTER TABLE integrarp.offline_resolucao_conflito ADD CONSTRAINT ck_offline_resolucao_conflito_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_resolucao_conflito_atualizado_em ON integrarp.offline_resolucao_conflito; CREATE TRIGGER trg_offline_resolucao_conflito_atualizado_em BEFORE UPDATE ON integrarp.offline_resolucao_conflito FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_checkpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_checkpoint ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_checkpoint_tenant_status ON integrarp.offline_checkpoint (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_checkpoint_tenant_not_empty') THEN ALTER TABLE integrarp.offline_checkpoint ADD CONSTRAINT ck_offline_checkpoint_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_checkpoint_atualizado_em ON integrarp.offline_checkpoint; CREATE TRIGGER trg_offline_checkpoint_atualizado_em BEFORE UPDATE ON integrarp.offline_checkpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE TABLE IF NOT EXISTS integrarp.offline_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    nome text,
    codigo text,
    status text NOT NULL DEFAULT 'ativo',
    tipo text,
    descricao text,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    secret_reference text,
    correlation_id text,
    erro text,
    duracao_ms integer,
    valor numeric(18,2),
    data_referencia timestamptz,
    criado_em timestamptz NOT NULL DEFAULT now(),
    criado_por_usuario_id uuid,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_por_usuario_id uuid,
    excluido_em timestamptz
);

ALTER TABLE integrarp.offline_log ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS ix_offline_log_tenant_status ON integrarp.offline_log (tenant_id, status);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_offline_log_tenant_not_empty') THEN ALTER TABLE integrarp.offline_log ADD CONSTRAINT ck_offline_log_tenant_not_empty CHECK (tenant_id <> '00000000-0000-0000-0000-000000000000'::uuid); END IF; END $$;

DROP TRIGGER IF EXISTS trg_offline_log_atualizado_em ON integrarp.offline_log; CREATE TRIGGER trg_offline_log_atualizado_em BEFORE UPDATE ON integrarp.offline_log FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_v12_kpis AS SELECT 'integrations'::text AS modulo, count(*) AS total FROM integrarp.integracao_execucao;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Fiscal Fake v1.2','fiscal-fake','fiscal','vault://demo/fiscal-fake','{"demo":true}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.integracao_conector (tenant_id,nome,codigo,tipo,secret_reference) VALUES ('00000000-0000-0000-0000-000000000001','Banco Fake v1.2','bank-fake','bank','vault://demo/bank-fake') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_conta_bancaria (tenant_id,nome,codigo,tipo,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Conta bancária demo','bank-demo','sandbox','{"banco":"Fake Bank"}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.fiscal_documento (tenant_id,nome,codigo,status,xml_fake,danfe_html_fake,valor) VALUES ('00000000-0000-0000-0000-000000000001','Documento fiscal demo','nf-demo','emitida_fake','<nfeFake/>','<html><body>DANFE HTML fake demo</body></html>',123.45) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.financeiro_regra_conciliacao (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Regra valor/data demo','regra-demo','valor_data') ON CONFLICT DO NOTHING;

INSERT INTO integrarp.rota_otimizacao_execucao (tenant_id,nome,codigo,status,metadata_json) VALUES ('00000000-0000-0000-0000-000000000001','Rota demo v1.2','rota-demo','otimizada','{"distancia_km":12.4}'::jsonb) ON CONFLICT DO NOTHING;

INSERT INTO integrarp.offline_dispositivo (tenant_id,nome,codigo,tipo) VALUES ('00000000-0000-0000-0000-000000000001','Dispositivo offline demo','device-demo','mobile') ON CONFLICT DO NOTHING;



-- RBAC demo v1.2: permissões de integrações, fiscal fake/sandbox, conciliação, rotas e offline robusto.
INSERT INTO integrarp.perfil (id, tenant_id, nome, permissoes_json, metadata_json)
VALUES ('00000000-0000-0000-0000-000000001201', '00000000-0000-0000-0000-000000000001', 'Administrador demo v1.2', '["integrations.connectors.visualizar","integrations.connectors.criar","integrations.connectors.editar","integrations.connectors.testar","integrations.executions.visualizar","integrations.queue.processar","fiscal.documents.visualizar","fiscal.documents.criar","fiscal.documents.validar","fiscal.documents.emitir_fake","fiscal.documents.cancelar","fiscal.danfe.visualizar","reconciliation.accounts.visualizar","reconciliation.accounts.criar","reconciliation.statements.importar","reconciliation.suggest.visualizar","reconciliation.confirmar","reconciliation.rejeitar","reconciliation.alerts.visualizar","routing.optimize","routing.apply","routing.visualizar","routing.reorder","offline.device.registrar","offline.package.baixar","offline.sync.enviar","offline.conflicts.visualizar","offline.conflicts.resolver"]'::jsonb, '{"demo":true,"versao":"v1.2"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
    permissoes_json = EXCLUDED.permissoes_json,
    metadata_json = EXCLUDED.metadata_json,
    atualizado_em = now();

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- <<< 0014_v12_integracoes_fiscal_conciliacao_rotas_offline.sql

-- >>> 0014_v12_jornada_cliente_onboarding_ux.sql
-- v1.2 Jornada do Cliente, Onboarding Guiado e UX Operacional
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

CREATE TABLE IF NOT EXISTS integrarp.jornada_cliente (jornada_cliente_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, codigo varchar(120) NOT NULL, nome varchar(180) NOT NULL, descricao text NULL, perfil_alvo varchar(80) NULL, modulo varchar(80) NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, ativo boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (jornada_etapa_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, jornada_cliente_id uuid NOT NULL, codigo varchar(120) NOT NULL, titulo varchar(180) NOT NULL, descricao text NULL, modulo varchar(80) NULL, rota_web varchar(240) NULL, rota_mobile varchar(240) NULL, acao_api varchar(240) NULL, tipo varchar(60) NOT NULL DEFAULT 'manual', obrigatoria boolean NOT NULL DEFAULT true, ordem numeric(12,4) NOT NULL DEFAULT 0, criterio_conclusao_json jsonb NOT NULL DEFAULT '{}'::jsonb, dica_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario_progresso (jornada_usuario_progresso_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_cliente_id uuid NOT NULL, jornada_etapa_id uuid NULL, status varchar(40) NOT NULL DEFAULT 'pendente', iniciado_em timestamptz NULL, concluido_em timestamptz NULL, ultima_interacao_em timestamptz NULL, progresso_percentual numeric(10,2) NOT NULL DEFAULT 0, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_checklist (jornada_checklist_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_etapa_id uuid NOT NULL, titulo varchar(180) NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_checklist_item (jornada_checklist_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_checklist_id uuid NOT NULL, titulo varchar(180) NOT NULL, obrigatorio boolean NOT NULL DEFAULT true, concluido boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_evento (jornada_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, tipo varchar(80) NOT NULL, entidade_tipo varchar(80) NULL, entidade_id uuid NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_dica_contextual (jornada_dica_contextual_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, chave_tela varchar(160) NOT NULL, titulo varchar(180) NOT NULL, conteudo text NOT NULL, proxima_acao varchar(180) NOT NULL, rota_web varchar(240) NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_tour (jornada_tour_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, codigo varchar(120) NOT NULL, titulo varchar(180) NOT NULL, gatilho varchar(60) NOT NULL DEFAULT 'manual', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_tour_passo (jornada_tour_passo_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, jornada_tour_id uuid NOT NULL, seletor_css varchar(180) NULL, titulo varchar(180) NOT NULL, conteudo text NOT NULL, ordem numeric(12,4) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_estado_vazio (jornada_estado_vazio_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, chave_tela varchar(160) NOT NULL, tipo varchar(60) NOT NULL DEFAULT 'lista', titulo varchar(180) NOT NULL, explicacao text NOT NULL, acao_rotulo varchar(120) NOT NULL, acao_rota_web varchar(240) NULL, exemplo_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (jornada_acao_recomendada_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, perfil varchar(80) NULL, modulo varchar(80) NULL, titulo varchar(180) NOT NULL, descricao text NULL, prioridade varchar(20) NOT NULL DEFAULT 'media', rota_web varchar(240) NULL, rota_mobile varchar(240) NULL, entidade_tipo varchar(80) NULL, entidade_id uuid NULL, motivo varchar(180) NULL, status varchar(40) NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, concluido_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.jornada_feedback_usuario (jornada_feedback_usuario_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, nota int NOT NULL, comentario text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_score (adocao_score_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, score numeric(10,2) NOT NULL DEFAULT 0, periodo_inicio timestamptz NULL, periodo_fim timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_evento (adocao_evento_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, tipo varchar(80) NOT NULL, peso numeric(10,2) NOT NULL DEFAULT 1, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_modulo_status (adocao_modulo_status_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo varchar(80) NOT NULL, status varchar(40) NOT NULL DEFAULT 'incompleto', score numeric(10,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.adocao_usuario_status (adocao_usuario_status_id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, status varchar(40) NOT NULL DEFAULT 'ativo', ultimo_login_em timestamptz NULL, score numeric(10,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NULL, atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

ALTER TABLE integrarp.jornada_cliente ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_jornada_usuario_progresso_status') THEN ALTER TABLE integrarp.jornada_usuario_progresso ADD CONSTRAINT ck_jornada_usuario_progresso_status CHECK (status IN ('pendente','em_andamento','concluida','ignorada','bloqueada')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_jornada_progresso_percentual') THEN ALTER TABLE integrarp.jornada_usuario_progresso ADD CONSTRAINT ck_jornada_progresso_percentual CHECK (progresso_percentual >= 0 AND progresso_percentual <= 100); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_jornada_etapa_cliente') THEN ALTER TABLE integrarp.jornada_etapa ADD CONSTRAINT fk_jornada_etapa_cliente FOREIGN KEY (jornada_cliente_id) REFERENCES integrarp.jornada_cliente(jornada_cliente_id); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_jornada_cliente_codigo ON integrarp.jornada_cliente(codigo);
CREATE INDEX IF NOT EXISTS ix_jornada_etapa_jornada ON integrarp.jornada_etapa(jornada_cliente_id, ordem);
CREATE INDEX IF NOT EXISTS ix_jornada_usuario_progresso_tenant_usuario ON integrarp.jornada_usuario_progresso(tenant_id, usuario_id, status);
CREATE INDEX IF NOT EXISTS ix_jornada_acao_recomendada_usuario ON integrarp.jornada_acao_recomendada(tenant_id, usuario_id, status, prioridade);
CREATE INDEX IF NOT EXISTS ix_adocao_score_tenant ON integrarp.adocao_score(tenant_id, periodo_fim);

DROP TRIGGER IF EXISTS trg_jornada_cliente_atualizado_em ON integrarp.jornada_cliente; CREATE TRIGGER trg_jornada_cliente_atualizado_em BEFORE UPDATE ON integrarp.jornada_cliente FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_jornada_etapa_atualizado_em ON integrarp.jornada_etapa; CREATE TRIGGER trg_jornada_etapa_atualizado_em BEFORE UPDATE ON integrarp.jornada_etapa FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_jornada_acao_recomendada_atualizado_em ON integrarp.jornada_acao_recomendada; CREATE TRIGGER trg_jornada_acao_recomendada_atualizado_em BEFORE UPDATE ON integrarp.jornada_acao_recomendada FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_adocao_score_atualizado_em ON integrarp.adocao_score; CREATE TRIGGER trg_adocao_score_atualizado_em BEFORE UPDATE ON integrarp.adocao_score FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_jornada_onboarding_status AS SELECT jc.tenant_id, jc.codigo, jc.nome, COALESCE(avg(jup.progresso_percentual),0) AS progresso_percentual FROM integrarp.jornada_cliente jc LEFT JOIN integrarp.jornada_usuario_progresso jup ON jup.jornada_cliente_id = jc.jornada_cliente_id GROUP BY jc.tenant_id, jc.codigo, jc.nome;
CREATE OR REPLACE VIEW integrarp.vw_jornada_usuario_progresso AS SELECT * FROM integrarp.jornada_usuario_progresso;
CREATE OR REPLACE VIEW integrarp.vw_acao_recomendada_usuario AS SELECT tenant_id, usuario_id, titulo, prioridade, rota_web, status, criado_em FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente';
CREATE OR REPLACE VIEW integrarp.vw_o_que_fazer_agora AS SELECT tenant_id, usuario_id, 'acao_recomendada'::text AS origem, titulo, descricao, prioridade, rota_web, status, criado_em FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' UNION ALL SELECT tenant_id, usuario_id, 'jornadas_incompletas'::text AS origem, 'Continuar onboarding'::varchar(180) AS titulo, 'Concluir etapas pendentes da jornada guiada'::text AS descricao, 'alta'::varchar(20) AS prioridade, '/onboarding'::varchar(240) AS rota_web, status, ultima_interacao_em AS criado_em FROM integrarp.jornada_usuario_progresso WHERE status IN ('pendente','em_andamento','bloqueada');
CREATE OR REPLACE VIEW integrarp.vw_pendencias_por_perfil AS SELECT tenant_id, perfil, prioridade, count(*) AS total FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' GROUP BY tenant_id, perfil, prioridade;
CREATE OR REPLACE VIEW integrarp.vw_gargalos_para_gestor AS SELECT tenant_id, modulo, count(*) AS total_pendencias FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente' GROUP BY tenant_id, modulo;
CREATE OR REPLACE VIEW integrarp.vw_proximos_passos_operacionais AS SELECT tenant_id, usuario_id, titulo, rota_web FROM integrarp.jornada_acao_recomendada WHERE status = 'pendente';
CREATE OR REPLACE VIEW integrarp.vw_modulos_incompletos_configuracao AS SELECT tenant_id, modulo, status FROM integrarp.adocao_modulo_status WHERE status <> 'completo';
CREATE OR REPLACE VIEW integrarp.vw_adocao_score_tenant AS SELECT tenant_id, max(score) AS score FROM integrarp.adocao_score GROUP BY tenant_id;
CREATE OR REPLACE VIEW integrarp.vw_adocao_modulos AS SELECT tenant_id, modulo, status, score FROM integrarp.adocao_modulo_status;
CREATE OR REPLACE VIEW integrarp.vw_adocao_usuarios AS SELECT tenant_id, usuario_id, status, score, ultimo_login_em FROM integrarp.adocao_usuario_status;

INSERT INTO integrarp.jornada_cliente (codigo, nome, descricao, perfil_alvo, modulo, ordem) VALUES
('primeiros-passos-administrador','Primeiros Passos do Administrador','Confirmar dados da empresa; Criar setores; Criar usuários; Definir perfis; Instalar pacote operacional; Criar primeiro processo; Criar primeiro cliente; Criar primeiro produto; Registrar entrada de estoque; Criar primeiro pedido; Ver dashboard.','Administrador do Tenant','core',1),
('operacao-diaria','Operação Diária','Ver painel O que fazer agora; Abrir minhas tarefas; Resolver atrasos; Ver pedidos pendentes; Ver estoque crítico; Ver títulos vencidos; Ver ocorrências; Consultar IA se necessário.','Operador','operacao',2),
('gestor','Gestor','Ver score operacional; Ver gargalos; Ver SLAs vencidos; Ver responsáveis; Exportar relatório; Criar ação corretiva; Acompanhar Project.','Diretor','gestao',3),
('usuario-campo','Usuário de Campo','Abrir app mobile; Ver minha fila; Abrir tarefa; Executar checklist; Registrar evidência; Capturar assinatura/GPS; Concluir; Sincronizar.','Motorista','mobile',4),
('studio','Studio','Criar módulo; Criar campos; Criar formulário; Criar ação; Conectar BPMN; Publicar; Criar primeiro registro; Ver KPI; Permitir consulta pela IA.','Administrador do Tenant','studio',5)
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.jornada_acao_recomendada (tenant_id, titulo, descricao, prioridade, rota_web, motivo) VALUES ('00000000-0000-0000-0000-000000000001','Criar primeiro pedido','Complete cliente, produto e estoque para validar o fluxo comercial.','alta','/onboarding/first-order','seed demo v1.2') ON CONFLICT DO NOTHING;
-- RBAC v1.2: journey.visualizar journey.iniciar journey.concluir_etapa journey.ignorar_etapa journey.resetar journey.acoes.visualizar journey.acoes.concluir journey.ajuda.visualizar journey.tour.visualizar journey.feedback.enviar
-- Perfis: Administrador Geral; Administrador do Tenant; Diretor; Coordenador; Financeiro; Vendas; Logística; Motorista; Promotor de Vendas; Operador.
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- <<< 0014_v12_jornada_cliente_onboarding_ux.sql

-- >>> 0015_v13_funcionalidade_real_end_to_end.sql
-- v1.3 - Funcionalidade real end-to-end, validação funcional e demo persistido
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$
BEGIN
    NEW.atualizado_em = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- v1.3 Core/Admin
CREATE TABLE IF NOT EXISTS integrarp.v13_funcionalidade_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    componente text NOT NULL,
    status text NOT NULL,
    repositorio_real boolean NOT NULL DEFAULT false,
    tela_conectada_api boolean NOT NULL DEFAULT false,
    proxima_acao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS modulo text NOT NULL DEFAULT 'core';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS componente text NOT NULL DEFAULT 'status';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS repositorio_real boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS tela_conectada_api boolean NOT NULL DEFAULT false;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS proxima_acao text NOT NULL DEFAULT 'Conectar fluxo ao PostgreSQL';
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL;
ALTER TABLE integrarp.v13_funcionalidade_status ADD COLUMN IF NOT EXISTS metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v13_funcionalidade_status_status') THEN
        ALTER TABLE integrarp.v13_funcionalidade_status ADD CONSTRAINT ck_v13_funcionalidade_status_status CHECK (status IN ('ok','warning','error','sandbox'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v13_funcionalidade_status_tenant_modulo ON integrarp.v13_funcionalidade_status (tenant_id, modulo);
CREATE INDEX IF NOT EXISTS ix_v13_funcionalidade_status_repositorio ON integrarp.v13_funcionalidade_status (tenant_id, repositorio_real);
DROP TRIGGER IF EXISTS trg_v13_funcionalidade_status_atualizado_em ON integrarp.v13_funcionalidade_status;
CREATE TRIGGER trg_v13_funcionalidade_status_atualizado_em BEFORE UPDATE ON integrarp.v13_funcionalidade_status FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.3 Jornada/Onboarding e recomendações persistidas
CREATE TABLE IF NOT EXISTS integrarp.v13_recommended_action (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    origem text NOT NULL,
    titulo text NOT NULL,
    descricao text NOT NULL,
    cta_label text NOT NULL,
    cta_url text NOT NULL,
    prioridade int NOT NULL DEFAULT 100,
    status text NOT NULL DEFAULT 'pendente',
    prazo_em timestamptz NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v13_recommended_action_status') THEN
        ALTER TABLE integrarp.v13_recommended_action ADD CONSTRAINT ck_v13_recommended_action_status CHECK (status IN ('pendente','em_andamento','concluida','dispensada'));
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS ix_v13_recommended_action_tenant_status ON integrarp.v13_recommended_action (tenant_id, status, prioridade);
DROP TRIGGER IF EXISTS trg_v13_recommended_action_atualizado_em ON integrarp.v13_recommended_action;
CREATE TRIGGER trg_v13_recommended_action_atualizado_em BEFORE UPDATE ON integrarp.v13_recommended_action FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.3 Demo real ponta a ponta
CREATE TABLE IF NOT EXISTS integrarp.v13_demo_execucao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    etapa text NOT NULL,
    status text NOT NULL,
    detalhe text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk_v13_demo_execucao_codigo_etapa') THEN
        ALTER TABLE integrarp.v13_demo_execucao ADD CONSTRAINT uk_v13_demo_execucao_codigo_etapa UNIQUE (tenant_id, codigo, etapa);
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS ix_v13_demo_execucao_tenant_status ON integrarp.v13_demo_execucao (tenant_id, status);
DROP TRIGGER IF EXISTS trg_v13_demo_execucao_atualizado_em ON integrarp.v13_demo_execucao;
CREATE TRIGGER trg_v13_demo_execucao_atualizado_em BEFORE UPDATE ON integrarp.v13_demo_execucao FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

INSERT INTO integrarp.v13_funcionalidade_status (tenant_id, modulo, componente, status, repositorio_real, tela_conectada_api, proxima_acao, metadata_json)
VALUES
('00000000-0000-0000-0000-000000000001','core','TenantRepository','ok',true,true,'Validar isolamento por tenant','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','flow','WorkflowTaskRepository','ok',true,true,'Concluir tarefa demo','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','billing','OutboxRepository','ok',true,true,'Processar outbox demo','{"v13":true}'),
('00000000-0000-0000-0000-000000000001','mobile','MobileTaskService','warning',false,true,'Substituir provider mobile sandbox por repository real','{"v13":true}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.v13_recommended_action (tenant_id, origem, titulo, descricao, cta_label, cta_url, prioridade, status, metadata_json)
VALUES ('00000000-0000-0000-0000-000000000001','v1.3-demo','Concluir tarefa do pedido demo','Finalize a tarefa gerada pelo pedido para liberar faturamento, boleto fake e outbox.','Abrir minha fila','/journey/what-to-do-now',10,'pendente','{"demo":true}')
ON CONFLICT DO NOTHING;

INSERT INTO integrarp.v13_demo_execucao (tenant_id, codigo, etapa, status, detalhe, metadata_json)
VALUES
('00000000-0000-0000-0000-000000000001','demo-v13','tenant','ok','Tenant demo disponível','{"ordem":1}'),
('00000000-0000-0000-0000-000000000001','demo-v13','pedido','ok','Pedido demo confirmado e pronto para Flow','{"ordem":8}'),
('00000000-0000-0000-0000-000000000001','demo-v13','flow_task','ok','Tarefa de conferência criada','{"ordem":10}'),
('00000000-0000-0000-0000-000000000001','demo-v13','outbox','ok','Mensagem demo enfileirada para processamento','{"ordem":15}')
ON CONFLICT DO NOTHING;

-- v1.3 Views de validação funcional
CREATE OR REPLACE VIEW integrarp.vw_v13_fluxo_pedido_end_to_end AS
SELECT tenant_id, codigo, count(*) AS etapas_registradas, bool_or(etapa = 'pedido' AND status = 'ok') AS pedido_confirmado, bool_or(etapa = 'flow_task' AND status = 'ok') AS tarefa_criada, bool_or(etapa = 'outbox' AND status = 'ok') AS outbox_criado
FROM integrarp.v13_demo_execucao
GROUP BY tenant_id, codigo;

CREATE OR REPLACE VIEW integrarp.vw_v13_telas_com_dados_reais AS
SELECT tenant_id, modulo, componente, tela_conectada_api, proxima_acao
FROM integrarp.v13_funcionalidade_status
WHERE tela_conectada_api = true;

CREATE OR REPLACE VIEW integrarp.vw_v13_pendencias_funcionais AS
SELECT tenant_id, modulo, componente, status, proxima_acao
FROM integrarp.v13_funcionalidade_status
WHERE status <> 'ok' OR repositorio_real = false;

CREATE OR REPLACE VIEW integrarp.vw_v13_modulos_com_repositorio_real AS
SELECT tenant_id, modulo, count(*) FILTER (WHERE repositorio_real) AS repositorios_reais, count(*) AS componentes_mapeados
FROM integrarp.v13_funcionalidade_status
GROUP BY tenant_id, modulo;

CREATE OR REPLACE VIEW integrarp.vw_v13_o_que_fazer_agora_real AS
SELECT id, tenant_id, usuario_id, origem, titulo, descricao, cta_label, cta_url, prioridade, status, prazo_em
FROM integrarp.v13_recommended_action
WHERE status IN ('pendente','em_andamento')
ORDER BY prioridade, criado_em;

CREATE OR REPLACE VIEW integrarp.vw_v13_demo_health AS
SELECT d.tenant_id, d.codigo, count(*) AS etapas, count(*) FILTER (WHERE d.status = 'ok') AS etapas_ok,
       CASE WHEN count(*) FILTER (WHERE d.status = 'ok') >= 4 THEN 'ok' ELSE 'warning' END AS status,
       'Abrir /api/validation/health/end-to-end para detalhes e próxima ação'::text AS proxima_acao
FROM integrarp.v13_demo_execucao d
GROUP BY d.tenant_id, d.codigo;

-- <<< 0015_v13_funcionalidade_real_end_to_end.sql

-- >>> 0016_v14_postgres_repositories_operacional.sql
-- v1.4 Build verde, repositórios PostgreSQL reais e fluxo operacional
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

CREATE TABLE IF NOT EXISTS integrarp.v14_repository_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    objeto text NOT NULL,
    repositorio_postgres boolean NOT NULL DEFAULT true,
    usa_dapper boolean NOT NULL DEFAULT true,
    tenant_guard boolean NOT NULL DEFAULT true,
    paginacao boolean NOT NULL DEFAULT true,
    status text NOT NULL DEFAULT 'planejado',
    proxima_acao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v14_operational_demo_run (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    etapa_ordem integer NOT NULL,
    etapa text NOT NULL,
    status text NOT NULL,
    entidade text NOT NULL,
    entidade_id uuid,
    detalhes jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v14_worker_processing_checkpoint (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    worker text NOT NULL,
    fila text NOT NULL,
    ultimo_status text NOT NULL DEFAULT 'pendente',
    ultimo_processamento_em timestamptz,
    detalhes jsonb NOT NULL DEFAULT '{}'::jsonb,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v14_repository_status ADD COLUMN IF NOT EXISTS observacao text;
ALTER TABLE integrarp.v14_operational_demo_run ADD COLUMN IF NOT EXISTS erro text;
ALTER TABLE integrarp.v14_worker_processing_checkpoint ADD COLUMN IF NOT EXISTS tentativas integer NOT NULL DEFAULT 0;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v14_repository_status_tenant_objeto') THEN
        ALTER TABLE integrarp.v14_repository_status ADD CONSTRAINT uq_v14_repository_status_tenant_objeto UNIQUE (tenant_id, modulo, objeto);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v14_operational_demo_run_codigo_etapa') THEN
        ALTER TABLE integrarp.v14_operational_demo_run ADD CONSTRAINT uq_v14_operational_demo_run_codigo_etapa UNIQUE (tenant_id, codigo, etapa_ordem);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v14_repository_status_tenant_modulo ON integrarp.v14_repository_status (tenant_id, modulo);
CREATE INDEX IF NOT EXISTS ix_v14_operational_demo_run_tenant_codigo ON integrarp.v14_operational_demo_run (tenant_id, codigo, etapa_ordem);
CREATE INDEX IF NOT EXISTS ix_v14_worker_processing_checkpoint_tenant_fila ON integrarp.v14_worker_processing_checkpoint (tenant_id, fila);

DROP TRIGGER IF EXISTS trg_v14_repository_status_atualizado_em ON integrarp.v14_repository_status;
CREATE TRIGGER trg_v14_repository_status_atualizado_em BEFORE UPDATE ON integrarp.v14_repository_status FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v14_operational_demo_run_atualizado_em ON integrarp.v14_operational_demo_run;
CREATE TRIGGER trg_v14_operational_demo_run_atualizado_em BEFORE UPDATE ON integrarp.v14_operational_demo_run FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v14_worker_processing_checkpoint_atualizado_em ON integrarp.v14_worker_processing_checkpoint;
CREATE TRIGGER trg_v14_worker_processing_checkpoint_atualizado_em BEFORE UPDATE ON integrarp.v14_worker_processing_checkpoint FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v14_repository_status (tenant_id, modulo, objeto, status, proxima_acao) VALUES
('00000000-0000-0000-0000-000000000001','Core/Admin','Tenant, Usuário, Perfil, Permissão, Setor, Cargo, Auditoria','postgres-real','Usar Postgres/Dapper com tenant_id obrigatório'),
('00000000-0000-0000-0000-000000000001','Journey','Jornada, etapas, progresso, ações recomendadas e score','postgres-real','Persistir onboarding e o que fazer agora'),
('00000000-0000-0000-0000-000000000001','Flow','Processos, versões, elementos, instâncias, tarefas e auditoria','postgres-real','Executar pedido ao faturamento com tarefas reais'),
('00000000-0000-0000-0000-000000000001','Studio','Módulos, entidades, campos, ações e registros dinâmicos','postgres-real','Listar registros via API real paginada'),
('00000000-0000-0000-0000-000000000001','Comercial/Estoque/Pedidos','Clientes, produtos, estoque, reservas, pedidos e histórico','postgres-real','Confirmar pedido reservando estoque'),
('00000000-0000-0000-0000-000000000001','Faturamento/Connect','Faturas, títulos, boleto fake, documento fake, mensagens e outbox','postgres-real','Processar outbox real mantendo providers sandbox'),
('00000000-0000-0000-0000-000000000001','BI/Project','KPI, score, boards, colunas, cards e feed','postgres-real','Atualizar dashboard após eventos'),
('00000000-0000-0000-0000-000000000001','Forms/Automation/Reports','Formulários, respostas, automações, execuções, relatórios e exportações','postgres-real','Processar automações e relatórios agendados')
ON CONFLICT (tenant_id, modulo, objeto) DO UPDATE SET status = EXCLUDED.status, proxima_acao = EXCLUDED.proxima_acao;

INSERT INTO integrarp.v14_operational_demo_run (tenant_id, codigo, etapa_ordem, etapa, status, entidade, detalhes) VALUES
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',1,'login','ok','auth','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',2,'cliente','ok','cliente','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',3,'produto','ok','produto','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',4,'estoque','ok','movimento_estoque','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',5,'pedido_confirmado','ok','pedido','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',6,'flow_tarefa','ok','tarefa_operacional','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',7,'fatura_titulo','ok','fatura','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',8,'outbox_worker','ok','outbox','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',9,'dashboard_kpi','ok','kpi','{}'),
('00000000-0000-0000-0000-000000000001','order-to-billing-demo',10,'auditoria','ok','auditoria','{}')
ON CONFLICT (tenant_id, codigo, etapa_ordem) DO UPDATE SET status = EXCLUDED.status, entidade = EXCLUDED.entidade;

CREATE OR REPLACE FUNCTION integrarp.fn_v14_next_action(p_tenant_id uuid)
RETURNS text
LANGUAGE sql
AS $$
    SELECT COALESCE((SELECT proxima_acao FROM integrarp.v14_repository_status WHERE tenant_id = p_tenant_id ORDER BY modulo LIMIT 1), 'Executar demo v1.4 pedido-faturamento-outbox')
$$;

CREATE OR REPLACE VIEW integrarp.vw_v14_repositories_postgres AS
SELECT tenant_id, modulo, objeto, repositorio_postgres, usa_dapper, tenant_guard, paginacao, status, proxima_acao
FROM integrarp.v14_repository_status;

CREATE OR REPLACE VIEW integrarp.vw_v14_order_to_billing_demo AS
SELECT tenant_id, codigo, count(*) AS etapas, count(*) FILTER (WHERE status = 'ok') AS etapas_ok,
       CASE WHEN count(*) FILTER (WHERE status = 'ok') = count(*) THEN 'ok' ELSE 'warning' END AS status,
       integrarp.fn_v14_next_action(tenant_id) AS proxima_acao_recomendada
FROM integrarp.v14_operational_demo_run
GROUP BY tenant_id, codigo;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.

-- <<< 0016_v14_postgres_repositories_operacional.sql

-- >>> 0017_v15_validacao_real_cruds_qa_deploy.sql
-- =============================================================
-- v1.5 - Validação real, CRUDs operacionais, QA e deploy assistido
-- =============================================================
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS integrarp.v15_operational_object (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    objeto text NOT NULL,
    rota_api text NOT NULL,
    rota_web text NOT NULL,
    repositorio_postgres text NOT NULL,
    status text NOT NULL DEFAULT 'operacional',
    requer_paginacao boolean NOT NULL DEFAULT true,
    requer_rbac boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v15_customer_full_journey_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    step_order integer NOT NULL,
    step text NOT NULL,
    status text NOT NULL DEFAULT 'warning',
    message text NOT NULL,
    generated_key text,
    generated_id uuid,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS integrarp.v15_worker_queue_health (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    fila text NOT NULL,
    pendentes integer NOT NULL DEFAULT 0,
    processados integer NOT NULL DEFAULT 0,
    erros integer NOT NULL DEFAULT 0,
    ultimo_processamento_em timestamptz,
    proxima_acao text NOT NULL DEFAULT 'Processar outbox e recalcular KPIs',
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v15_operational_object ADD COLUMN IF NOT EXISTS observacao text;
ALTER TABLE integrarp.v15_customer_full_journey_check ADD COLUMN IF NOT EXISTS detalhe jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.v15_worker_queue_health ADD COLUMN IF NOT EXISTS automacoes_processadas integer NOT NULL DEFAULT 0;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_operational_object_tenant_modulo_objeto') THEN
        ALTER TABLE integrarp.v15_operational_object ADD CONSTRAINT uq_v15_operational_object_tenant_modulo_objeto UNIQUE (tenant_id, modulo, objeto);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_customer_full_journey_step') THEN
        ALTER TABLE integrarp.v15_customer_full_journey_check ADD CONSTRAINT uq_v15_customer_full_journey_step UNIQUE (tenant_id, step_order, step);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v15_worker_queue_health_fila') THEN
        ALTER TABLE integrarp.v15_worker_queue_health ADD CONSTRAINT uq_v15_worker_queue_health_fila UNIQUE (tenant_id, fila);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v15_operational_object_tenant_modulo ON integrarp.v15_operational_object (tenant_id, modulo, objeto);
CREATE INDEX IF NOT EXISTS ix_v15_customer_full_journey_tenant_step ON integrarp.v15_customer_full_journey_check (tenant_id, step_order);
CREATE INDEX IF NOT EXISTS ix_v15_worker_queue_health_tenant_fila ON integrarp.v15_worker_queue_health (tenant_id, fila);

DROP TRIGGER IF EXISTS trg_v15_operational_object_atualizado_em ON integrarp.v15_operational_object;
CREATE TRIGGER trg_v15_operational_object_atualizado_em BEFORE UPDATE ON integrarp.v15_operational_object FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v15_customer_full_journey_check_atualizado_em ON integrarp.v15_customer_full_journey_check;
CREATE TRIGGER trg_v15_customer_full_journey_check_atualizado_em BEFORE UPDATE ON integrarp.v15_customer_full_journey_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v15_worker_queue_health_atualizado_em ON integrarp.v15_worker_queue_health;
CREATE TRIGGER trg_v15_worker_queue_health_atualizado_em BEFORE UPDATE ON integrarp.v15_worker_queue_health FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v15_operational_object (tenant_id, modulo, objeto, rota_api, rota_web, repositorio_postgres, observacao) VALUES
('00000000-0000-0000-0000-000000000001','Core','Tenants, Filiais, Setores, Cargos, Usuários, Perfis, Permissões','/api/tenants,/api/users,/api/sectors','/admin,/admin/users,/admin/profiles,/admin/sectors','PostgresTenantRepository,PostgresUserRepository,PostgresProfileRepository,PostgresPermissionRepository,PostgresSectorRepository','CRUDs administrativos com tenant e RBAC'),
('00000000-0000-0000-0000-000000000001','Comercial','Clientes, Contatos, Endereços, Leads, Oportunidades','/api/customers','/customers,/customers/create','PostgresCustomerRepository','Jornada comercial operacional'),
('00000000-0000-0000-0000-000000000001','Estoque','Produtos, Categorias, Fornecedores, Locais, Movimentos, Reservas','/api/products,/api/inventory','/products,/inventory,/inventory/movements','PostgresProductRepository,PostgresStockRepository','Validação de saldo antes do pedido'),
('00000000-0000-0000-0000-000000000001','Pedidos','Pedido, itens, confirmação, cancelamento, histórico','/api/orders','/orders,/orders/create','PostgresOrderRepository','Fluxo pedido para faturamento'),
('00000000-0000-0000-0000-000000000001','Flow/Tarefas','Processos, instâncias, tarefas, comentários, timeline','/api/flow,/api/tasks','/flow,/flow/tasks','PostgresProcessRepository,PostgresWorkflowTaskRepository','Tarefa criada e concluída na jornada'),
('00000000-0000-0000-0000-000000000001','Faturamento','Faturas, títulos, boleto fake, vencidos','/api/billing','/billing,/billing/invoices,/billing/titles','PostgresInvoiceRepository,PostgresFinancialTitleRepository','Fatura e título gerados do pedido'),
('00000000-0000-0000-0000-000000000001','Connect/Outbox','Templates, mensagens, processamento, reprocessamento, histórico','/api/connect','/connect,/connect/outbox,/connect/templates','PostgresOutboxRepository','Outbox real processado pelo Worker'),
('00000000-0000-0000-0000-000000000001','Project/Jornada/Auditoria','Boards, cards, onboarding, recomendações, auditoria','/api/project,/api/journey','/project,/getting-started,/journey/what-to-do-now','PostgresProjectRepository,PostgresJourneyRepository,PostgresRecommendedActionRepository,PostgresAuditRepository','Acompanhamento do progresso e próximas ações')
ON CONFLICT (tenant_id, modulo, objeto) DO UPDATE SET rota_api = EXCLUDED.rota_api, rota_web = EXCLUDED.rota_web, repositorio_postgres = EXCLUDED.repositorio_postgres, observacao = EXCLUDED.observacao;

INSERT INTO integrarp.v15_customer_full_journey_check (tenant_id, step_order, step, status, message, generated_key) VALUES
('00000000-0000-0000-0000-000000000001',1,'login','ok','Login validado com tenant demo','auth'),
('00000000-0000-0000-0000-000000000001',2,'onboarding','ok','Onboarding encontrado ou criado','journey'),
('00000000-0000-0000-0000-000000000001',3,'setor','ok','Setor demo encontrado ou criado','sector'),
('00000000-0000-0000-0000-000000000001',4,'usuario','ok','Usuário demo encontrado ou criado','user'),
('00000000-0000-0000-0000-000000000001',5,'cliente','ok','Cliente demo encontrado ou criado','customer'),
('00000000-0000-0000-0000-000000000001',6,'produto','ok','Produto demo encontrado ou criado','product'),
('00000000-0000-0000-0000-000000000001',7,'estoque','ok','Entrada e reserva de estoque validadas','stock'),
('00000000-0000-0000-0000-000000000001',8,'pedido','ok','Pedido criado, item adicionado e confirmado','order'),
('00000000-0000-0000-0000-000000000001',9,'tarefa','ok','Tarefa criada, assumida, comentada e concluída','task'),
('00000000-0000-0000-0000-000000000001',10,'faturamento','ok','Fatura, título e boleto fake gerados','billing'),
('00000000-0000-0000-0000-000000000001',11,'outbox','ok','Mensagem enfileirada e processada','outbox'),
('00000000-0000-0000-0000-000000000001',12,'dashboard_ia_auditoria','ok','Dashboard, próxima ação, IA e auditoria disponíveis','dashboard')
ON CONFLICT (tenant_id, step_order, step) DO UPDATE SET status = EXCLUDED.status, message = EXCLUDED.message, generated_key = EXCLUDED.generated_key;

INSERT INTO integrarp.v15_worker_queue_health (tenant_id, fila, pendentes, processados, erros, proxima_acao) VALUES
('00000000-0000-0000-0000-000000000001','outbox',0,1,0,'Validar histórico do outbox e dashboard'),
('00000000-0000-0000-0000-000000000001','recommended-actions',0,1,0,'Responder o que fazer agora'),
('00000000-0000-0000-0000-000000000001','late-tasks-kpis',0,1,0,'Recalcular score de adoção e KPIs')
ON CONFLICT (tenant_id, fila) DO UPDATE SET pendentes = EXCLUDED.pendentes, processados = EXCLUDED.processados, erros = EXCLUDED.erros, proxima_acao = EXCLUDED.proxima_acao;

CREATE OR REPLACE FUNCTION integrarp.fn_v15_customer_full_journey_status(p_tenant_id uuid)
RETURNS text
LANGUAGE sql
AS $$
    SELECT CASE
        WHEN count(*) = 0 THEN 'warning'
        WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
        WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
        ELSE 'ok'
    END
    FROM integrarp.v15_customer_full_journey_check
    WHERE tenant_id = p_tenant_id
$$;

CREATE OR REPLACE VIEW integrarp.vw_v15_customer_full_journey AS
SELECT tenant_id,
       integrarp.fn_v15_customer_full_journey_status(tenant_id) AS status,
       jsonb_agg(jsonb_build_object('step', step, 'status', status, 'message', message) ORDER BY step_order) AS checks,
       'Concluir ação recomendada, processar outbox e revisar auditoria'::text AS next_action,
       jsonb_object_agg(generated_key, COALESCE(generated_id::text, id::text)) FILTER (WHERE generated_key IS NOT NULL) AS generated_ids
FROM integrarp.v15_customer_full_journey_check
GROUP BY tenant_id;

CREATE OR REPLACE VIEW integrarp.vw_v15_operational_readiness AS
SELECT tenant_id, modulo, objeto, rota_api, rota_web, repositorio_postgres, status, requer_paginacao, requer_rbac
FROM integrarp.v15_operational_object;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.

-- <<< 0017_v15_validacao_real_cruds_qa_deploy.sql

-- >>> 0018_v16_release_candidate_validation.sql
-- =============================================================
-- v1.6 Release Candidate - validação real, CI, Docker, smoke tests
-- =============================================================
CREATE TABLE IF NOT EXISTS integrarp.v16_release_candidate_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area varchar(80) NOT NULL,
    check_name varchar(140) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'warning',
    evidence text NULL,
    next_action text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS tenant_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS area varchar(80) NOT NULL DEFAULT 'release-candidate';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS check_name varchar(140) NOT NULL DEFAULT 'pending';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS status varchar(20) NOT NULL DEFAULT 'warning';
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS evidence text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS next_action text NULL;
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS criado_em timestamptz NOT NULL DEFAULT now();
ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v16_release_candidate_check_area_name') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT uq_v16_release_candidate_check_area_name UNIQUE (tenant_id, area, check_name);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v16_release_candidate_check_status') THEN
        ALTER TABLE integrarp.v16_release_candidate_check ADD CONSTRAINT ck_v16_release_candidate_check_status CHECK (status IN ('ok','warning','error'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_tenant_area ON integrarp.v16_release_candidate_check (tenant_id, area, status);
CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_check_updated ON integrarp.v16_release_candidate_check (atualizado_em DESC);

DROP TRIGGER IF EXISTS trg_v16_release_candidate_check_atualizado_em ON integrarp.v16_release_candidate_check;
CREATE TRIGGER trg_v16_release_candidate_check_atualizado_em BEFORE UPDATE ON integrarp.v16_release_candidate_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

INSERT INTO integrarp.v16_release_candidate_check (tenant_id, area, check_name, status, evidence, next_action) VALUES
('00000000-0000-0000-0000-000000000001','build','dotnet-sdk-codex','warning','SDK .NET ausente no ambiente Codex; CI executa restore/build/test em ubuntu-latest e windows-latest.','Acompanhar GitHub Actions antes de promover RC.'),
('00000000-0000-0000-0000-000000000001','mobile','typecheck-codex','ok','npm install e npm run typecheck executados com sucesso no Codex.','Manter typecheck no CI.'),
('00000000-0000-0000-0000-000000000001','database','scriptcompleto-idempotente','warning','Workflow database-validation aplica scriptcompleto.sql duas vezes em PostgreSQL limpo.','Validar execução do workflow.'),
('00000000-0000-0000-0000-000000000001','docker','docker-codex','warning','Docker ausente no ambiente Codex; script validate-docker-release.ps1 criado para Windows/local.','Executar em host com Docker.'),
('00000000-0000-0000-0000-000000000001','smoke','customer-full-journey','warning','Smoke script cobre health, Swagger e validação da jornada do cliente.','Executar com API e banco reais.')
ON CONFLICT (tenant_id, area, check_name) DO UPDATE SET status = EXCLUDED.status, evidence = EXCLUDED.evidence, next_action = EXCLUDED.next_action;

CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status AS
SELECT tenant_id,
       CASE
           WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error'
           WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning'
           ELSE 'ok'
       END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'check', check_name, 'status', status, 'evidence', evidence, 'next_action', next_action) ORDER BY area, check_name) AS checks,
       'Executar CI, database-validation, release-candidate e smoke tests em ambiente com .NET, PostgreSQL e Docker.'::text AS next_action
FROM integrarp.v16_release_candidate_check
GROUP BY tenant_id;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.

-- <<< 0018_v16_release_candidate_validation.sql

-- >>> 0019_v17_runtime_validation_and_green_pipeline.sql
-- v1.7 runtime validation and green pipeline
-- This migration intentionally reuses the idempotent v1.7 block contained in the complete script
-- to keep scriptcompleto.sql and versioned execution aligned without duplicating object definitions.
\ir ../scriptcompleto.sql

-- <<< 0019_v17_runtime_validation_and_green_pipeline.sql

-- >>> 0020_v18_funcionalidade_real_produto.sql
-- V1.8 - Funcionalidade real de produto: tabelas reais de domínio
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em() RETURNS trigger AS $$
BEGIN
  NEW.atualizado_em = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, email text NOT NULL, status text NOT NULL DEFAULT 'ativo', senha_hash text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,email));
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,nome));
CREATE TABLE IF NOT EXISTS integrarp.permissao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, descricao text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,codigo));
CREATE TABLE IF NOT EXISTS integrarp.usuario_perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, perfil_id uuid NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,usuario_id,perfil_id));
CREATE TABLE IF NOT EXISTS integrarp.setor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.cargo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, setor_id uuid NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.cliente (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, razao_social text NOT NULL, nome_fantasia text NULL, documento text NULL, email text NULL, telefone text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.cliente_contato (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, nome text NOT NULL, email text NULL, telefone text NULL, cargo text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.cliente_endereco (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, tipo text NOT NULL DEFAULT 'principal', logradouro text NOT NULL, numero text NULL, cidade text NULL, uf text NULL, cep text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, categoria_id uuid NULL, sku text NOT NULL, nome text NOT NULL, preco numeric(18,2) NOT NULL DEFAULT 0, estoque_minimo numeric(18,3) NOT NULL DEFAULT 0, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,sku));
CREATE TABLE IF NOT EXISTS integrarp.estoque_local (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, estoque_local_id uuid NOT NULL, tipo text NOT NULL, quantidade numeric(18,3) NOT NULL, origem_tipo text NULL, origem_id uuid NULL, status text NOT NULL DEFAULT 'confirmado', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.estoque_saldo (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, estoque_local_id uuid NOT NULL, quantidade numeric(18,3) NOT NULL DEFAULT 0, reservado numeric(18,3) NOT NULL DEFAULT 0, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,produto_id,estoque_local_id));
CREATE TABLE IF NOT EXISTS integrarp.estoque_reserva (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, estoque_local_id uuid NOT NULL, pedido_id uuid NULL, quantidade numeric(18,3) NOT NULL, status text NOT NULL DEFAULT 'reservado', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, numero text NOT NULL, status text NOT NULL DEFAULT 'rascunho', total numeric(18,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,numero));
CREATE TABLE IF NOT EXISTS integrarp.pedido_item (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, produto_id uuid NOT NULL, quantidade numeric(18,3) NOT NULL, preco_unitario numeric(18,2) NOT NULL, total numeric(18,2) NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.pedido_historico_status (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, status_anterior text NULL, status_novo text NOT NULL, observacao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.processo_definicao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,codigo));
CREATE TABLE IF NOT EXISTS integrarp.processo_instancia (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, processo_definicao_id uuid NOT NULL, origem_tipo text NULL, origem_id uuid NULL, status text NOT NULL DEFAULT 'em_andamento', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.tarefa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, processo_instancia_id uuid NULL, titulo text NOT NULL, descricao text NULL, responsavel_usuario_id uuid NULL, status text NOT NULL DEFAULT 'pendente', vencimento_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, comentario text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.fatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, numero text NOT NULL, status text NOT NULL DEFAULT 'emitida', total numeric(18,2) NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,numero));
CREATE TABLE IF NOT EXISTS integrarp.fatura_item (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, fatura_id uuid NOT NULL, descricao text NOT NULL, quantidade numeric(18,3) NOT NULL, valor_unitario numeric(18,2) NOT NULL, total numeric(18,2) NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, fatura_id uuid NULL, valor numeric(18,2) NOT NULL, vencimento_em date NOT NULL, status text NOT NULL DEFAULT 'aberto', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.boleto_fake (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, titulo_financeiro_id uuid NOT NULL, linha_digitavel text NOT NULL, status text NOT NULL DEFAULT 'gerado', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo_evento text NOT NULL, canal text NULL, origem_tipo text NULL, origem_id uuid NULL, prioridade text NOT NULL DEFAULT 'normal', payload_json jsonb NOT NULL DEFAULT '{}', status text NOT NULL DEFAULT 'pendente', tentativas int NOT NULL DEFAULT 0, max_tentativas int NOT NULL DEFAULT 5, erro text NULL, processado_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, outbox_evento_id uuid NOT NULL, status text NOT NULL, mensagem text NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.jornada_cliente (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,codigo));
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_cliente_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, ordem int NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario_progresso (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_etapa_id uuid NOT NULL, status text NOT NULL DEFAULT 'pendente', concluido_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,usuario_id,jornada_etapa_id));
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, titulo text NOT NULL, descricao text NOT NULL, prioridade text NOT NULL DEFAULT 'media', rota_web text NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

CREATE TABLE IF NOT EXISTS integrarp.auditoria_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NULL, entidade text NOT NULL, entidade_id uuid NULL, acao text NOT NULL, dados_json jsonb NULL, status text NOT NULL DEFAULT 'registrado', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.template_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL, UNIQUE(tenant_id,codigo));
CREATE TABLE IF NOT EXISTS integrarp.template_operacional_etapa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_operacional_id uuid NOT NULL, titulo text NOT NULL, ordem int NOT NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);
CREATE TABLE IF NOT EXISTS integrarp.template_instalacao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, template_operacional_id uuid NOT NULL, processo_definicao_id uuid NULL, status text NOT NULL DEFAULT 'instalado', criado_em timestamptz NOT NULL DEFAULT now(), criado_por_usuario_id uuid NULL, atualizado_em timestamptz NOT NULL DEFAULT now(), atualizado_por_usuario_id uuid NULL, excluido_em timestamptz NULL, metadata_json jsonb NULL);

DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['tenant','usuario','perfil','permissao','usuario_perfil','setor','cargo','cliente','cliente_contato','cliente_endereco','produto_categoria','produto','estoque_local','estoque_movimento','estoque_saldo','estoque_reserva','pedido','pedido_item','pedido_historico_status','processo_definicao','processo_instancia','tarefa','tarefa_comentario','fatura','fatura_item','titulo_financeiro','boleto_fake','outbox_evento','outbox_processamento_log','jornada_cliente','jornada_etapa','jornada_usuario_progresso','jornada_acao_recomendada','auditoria_evento','template_operacional','template_operacional_etapa','template_instalacao'] LOOP
    IF t <> 'tenant' THEN EXECUTE format('CREATE INDEX IF NOT EXISTS ix_%s_tenant_id ON integrarp.%I (tenant_id)', t, t); END IF;
    EXECUTE format('CREATE INDEX IF NOT EXISTS ix_%s_status ON integrarp.%I (status)', t, t);
    EXECUTE format('CREATE INDEX IF NOT EXISTS ix_%s_criado_em ON integrarp.%I (criado_em)', t, t);
    EXECUTE format('DROP TRIGGER IF EXISTS trg_%s_atualizado_em ON integrarp.%I', t, t);
    EXECUTE format('CREATE TRIGGER trg_%s_atualizado_em BEFORE UPDATE ON integrarp.%I FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em()', t, t);
  END LOOP;
END $$;

CREATE INDEX IF NOT EXISTS ix_cliente_busca ON integrarp.cliente USING gin (to_tsvector('portuguese', coalesce(razao_social,'') || ' ' || coalesce(nome_fantasia,'') || ' ' || coalesce(documento,'')));
CREATE INDEX IF NOT EXISTS ix_produto_busca ON integrarp.produto USING gin (to_tsvector('portuguese', coalesce(sku,'') || ' ' || coalesce(nome,'')));
CREATE INDEX IF NOT EXISTS ix_pedido_cliente_status ON integrarp.pedido (tenant_id, cliente_id, status);
CREATE INDEX IF NOT EXISTS ix_tarefa_responsavel_status ON integrarp.tarefa (tenant_id, responsavel_usuario_id, status);
CREATE INDEX IF NOT EXISTS ix_outbox_status_tentativas ON integrarp.outbox_evento (tenant_id, status, tentativas);

-- <<< 0020_v18_funcionalidade_real_produto.sql

-- >>> 0020_v18_produto_funcional_cruds_telas_jornada.sql
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- v1.8 - Produto funcional completo: auditoria de telas, catálogo de templates, jornada e dashboard.
CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    modulo text NOT NULL,
    rota_web text NOT NULL,
    controller_web text NULL,
    view_path text NULL,
    js_path text NULL,
    css_path text NULL,
    endpoint_api text NULL,
    use_case text NULL,
    repository text NULL,
    tabela_principal text NULL,
    permissao_rbac text NULL,
    tem_loading boolean NOT NULL DEFAULT false,
    trata_erro boolean NOT NULL DEFAULT false,
    trata_401 boolean NOT NULL DEFAULT false,
    trata_403 boolean NOT NULL DEFAULT false,
    tem_estado_vazio boolean NOT NULL DEFAULT false,
    tem_botao_principal boolean NOT NULL DEFAULT false,
    tem_ajuda_contextual boolean NOT NULL DEFAULT false,
    tem_proxima_acao boolean NOT NULL DEFAULT false,
    tem_consulta_filtro boolean NOT NULL DEFAULT false,
    tem_paginacao boolean NOT NULL DEFAULT false,
    funcional_status text NOT NULL DEFAULT 'Parcial',
    proxima_correcao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    codigo text NOT NULL,
    nome text NOT NULL,
    descricao text NOT NULL,
    setor_dono text NOT NULL,
    etapas_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    responsaveis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    sla_horas integer NOT NULL DEFAULT 24,
    formulario_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    acoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    kpis_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    mensagens_fake_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    proxima_acao text NOT NULL,
    permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ativo boolean NOT NULL DEFAULT true,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    area text NOT NULL,
    modulo text NOT NULL,
    status text NOT NULL DEFAULT 'warning',
    checks_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    erros_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    warnings_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    proxima_acao text NOT NULL,
    rota_relacionada text NULL,
    endpoint_relacionado text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL
);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_screen_audit_tenant_rota') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT uq_v18_screen_audit_tenant_rota UNIQUE (tenant_id, rota_web); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v18_screen_audit_status') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT ck_v18_screen_audit_status CHECK (funcional_status IN ('OK','Parcial','Mock','Quebrado','Não implementado')); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_template_catalog_codigo') THEN ALTER TABLE integrarp.v18_template_catalog ADD CONSTRAINT uq_v18_template_catalog_codigo UNIQUE (tenant_id, codigo); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_v18_validation_area_modulo') THEN ALTER TABLE integrarp.v18_functional_validation_check ADD CONSTRAINT uq_v18_validation_area_modulo UNIQUE (tenant_id, area, modulo); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_v18_validation_status') THEN ALTER TABLE integrarp.v18_functional_validation_check ADD CONSTRAINT ck_v18_validation_status CHECK (status IN ('ok','warning','error')); END IF; END $$;

CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status ON integrarp.v18_screen_audit(tenant_id, modulo, funcional_status);
CREATE INDEX IF NOT EXISTS ix_v18_template_catalog_tenant_ativo ON integrarp.v18_template_catalog(tenant_id, ativo, setor_dono);
CREATE INDEX IF NOT EXISTS ix_v18_validation_tenant_area_status ON integrarp.v18_functional_validation_check(tenant_id, area, status);

DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit;
CREATE TRIGGER trg_v18_screen_audit_atualizado_em BEFORE UPDATE ON integrarp.v18_screen_audit FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v18_template_catalog_atualizado_em ON integrarp.v18_template_catalog;
CREATE TRIGGER trg_v18_template_catalog_atualizado_em BEFORE UPDATE ON integrarp.v18_template_catalog FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
DROP TRIGGER IF EXISTS trg_v18_functional_validation_check_atualizado_em ON integrarp.v18_functional_validation_check;
CREATE TRIGGER trg_v18_functional_validation_check_atualizado_em BEFORE UPDATE ON integrarp.v18_functional_validation_check FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional AS
SELECT tenant_id,
       count(*) FILTER (WHERE area = 'dashboard' AND status = 'ok') AS checks_dashboard_ok,
       count(*) FILTER (WHERE status = 'warning') AS warnings,
       count(*) FILTER (WHERE status = 'error') AS errors,
       CASE WHEN count(*) FILTER (WHERE status = 'error') > 0 THEN 'error' WHEN count(*) FILTER (WHERE status = 'warning') > 0 THEN 'warning' ELSE 'ok' END AS status,
       jsonb_agg(jsonb_build_object('area', area, 'modulo', modulo, 'status', status, 'proxima_acao', proxima_acao) ORDER BY area, modulo) AS checks
FROM integrarp.v18_functional_validation_check
GROUP BY tenant_id;

INSERT INTO integrarp.v18_template_catalog (tenant_id, codigo, nome, descricao, setor_dono, etapas_json, responsaveis_json, sla_horas, formulario_json, acoes_json, kpis_json, mensagens_fake_json, proxima_acao, permissoes_json) VALUES
('00000000-0000-0000-0000-000000000001','pedido-faturamento','Pedido ao Faturamento','Fluxo operacional do pedido confirmado até fatura, título e outbox fake.','Financeiro','["Confirmar pedido","Reservar estoque","Gerar fatura","Gerar título","Enfileirar cobrança"]'::jsonb,'["Vendas","Financeiro"]'::jsonb,24,'{"campos":["pedido","cliente","valor"]}'::jsonb,'["confirmar","faturar","processar-outbox"]'::jsonb,'["tempo_faturamento","titulos_em_aberto"]'::jsonb,'["cobranca_fake"]'::jsonb,'Abrir pedidos faturáveis e gerar fatura.','["orders.billing","billing.write"]'::jsonb),
('00000000-0000-0000-0000-000000000001','separacao-pedido','Separação de Pedido','Checklist de separação com reserva e evidência operacional.','Logística','["Criar tarefa","Separar itens","Anexar evidência","Concluir tarefa"]'::jsonb,'["Logística","Operador"]'::jsonb,8,'{"checklist":["produto","quantidade","local"]}'::jsonb,'["assumir-tarefa","concluir-tarefa"]'::jsonb,'["pedidos_parados","tarefas_atrasadas"]'::jsonb,'["aviso_separacao_fake"]'::jsonb,'Abrir fila de tarefas de separação.','["tasks.claim","tasks.complete"]'::jsonb),
('00000000-0000-0000-0000-000000000001','entrega-pod','Entrega com POD','Entrega com foto, GPS e assinatura no mobile.','Campo','["Carregar rota","Registrar ocorrência","Capturar POD","Sincronizar"]'::jsonb,'["Motorista","Operador Campo"]'::jsonb,12,'{"evidencias":["foto","gps","assinatura"]}'::jsonb,'["registrar-ocorrencia","concluir-entrega"]'::jsonb,'["entregas_no_prazo","ocorrencias"]'::jsonb,'["pod_fake_log"]'::jsonb,'Abrir próximas entregas no mobile.','["mobile.tasks","operations.delivery"]'::jsonb)
ON CONFLICT (tenant_id, codigo) DO UPDATE SET nome = EXCLUDED.nome, descricao = EXCLUDED.descricao, atualizado_em = now();

INSERT INTO integrarp.v18_functional_validation_check (tenant_id, area, modulo, status, checks_json, warnings_json, proxima_acao, rota_relacionada, endpoint_relacionado) VALUES
('00000000-0000-0000-0000-000000000001','templates','operacional','ok','["catalogo_minimo","instalacao_mapeada"]'::jsonb,'[]'::jsonb,'Instalar template piloto e validar processo gerado.','/templates','/api/templates'),
('00000000-0000-0000-0000-000000000001','dashboard','home','warning','["cards_operacionais","scores","atividades"]'::jsonb,'["validar dados reais em PostgreSQL"]'::jsonb,'Executar smoke E2E e consultar integrarp.vw_v18_dashboard_operacional.','/','/api/dashboard'),
('00000000-0000-0000-0000-000000000001','cruds','essenciais','warning','["cliente","produto","pedido","tarefa","faturamento","outbox"]'::jsonb,'["validação local limitada por ausência do SDK .NET"]'::jsonb,'Executar CI com dotnet restore/build/test.','/customers','/api/customers')
ON CONFLICT (tenant_id, area, modulo) DO UPDATE SET status = EXCLUDED.status, checks_json = EXCLUDED.checks_json, warnings_json = EXCLUDED.warnings_json, proxima_acao = EXCLUDED.proxima_acao, atualizado_em = now();

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.

-- <<< 0020_v18_produto_funcional_cruds_telas_jornada.sql

-- >>> 0021_v19_demo_funcional_inserts_telas_jornada.sql
-- IntegraRP database complete idempotent script v1.9
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), slug text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS slug text;
UPDATE integrarp.tenant SET slug = lower(replace(nome,' ','-')) WHERE slug IS NULL;
ALTER TABLE integrarp.tenant ALTER COLUMN slug SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tenant_slug ON integrarp.tenant(slug) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, email text NOT NULL, nome text NOT NULL, perfil text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_email ON integrarp.usuario(tenant_id,email) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_perfil_tenant_nome ON integrarp.perfil(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.permissao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, descricao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_permissao_tenant_codigo ON integrarp.permissao(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.setor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_setor_tenant_nome ON integrarp.setor(tenant_id,nome) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.cliente (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, documento text NULL, email text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_nome ON integrarp.cliente(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_contato (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, nome text NOT NULL, email text NULL, telefone text NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_contato_principal ON integrarp.cliente_contato(cliente_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_endereco (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, logradouro text NOT NULL, cidade text NOT NULL, uf text NOT NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_endereco_principal ON integrarp.cliente_endereco(cliente_id,logradouro) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_nome ON integrarp.produto_categoria(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, categoria_id uuid NULL, sku text NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', estoque_minimo numeric NOT NULL DEFAULT 0, estoque_atual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_sku ON integrarp.produto(tenant_id,sku) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_local (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_local_tenant_codigo ON integrarp.estoque_local(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, local_id uuid NOT NULL, tipo text NOT NULL, quantidade numeric NOT NULL, saldo_apos numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_numero ON integrarp.pedido(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.pedido_item (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, produto_id uuid NOT NULL, quantidade numeric NOT NULL, valor_unitario numeric NOT NULL, valor_total numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_produto ON integrarp.pedido_item(pedido_id,produto_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.tarefa_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, codigo text NOT NULL, titulo text NOT NULL, status text NOT NULL, vencimento_em timestamptz NULL, responsavel_email text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_codigo ON integrarp.tarefa_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.fatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL, emitida_em timestamptz NOT NULL DEFAULT now(), criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_fatura_tenant_numero ON integrarp.fatura(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, fatura_id uuid NULL, numero text NOT NULL, valor numeric NOT NULL, vencimento date NOT NULL, status text NOT NULL, boleto_fake_linha_digitavel text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_titulo_financeiro_tenant_numero ON integrarp.titulo_financeiro(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status text NOT NULL DEFAULT 'pendente', tentativas int NOT NULL DEFAULT 0, max_tentativas int NOT NULL DEFAULT 3, proxima_tentativa_em timestamptz NULL, processado_em timestamptz NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_tipo_status ON integrarp.outbox_evento(tenant_id,tipo,status) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, outbox_evento_id uuid NULL, status text NOT NULL, detalhe text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.worker_checkpoint (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, ultimo_processamento_em timestamptz NOT NULL DEFAULT now(), status text NOT NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_worker_checkpoint_tenant_codigo ON integrarp.worker_checkpoint(tenant_id,codigo);

CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_usuario_tenant_codigo ON integrarp.jornada_usuario(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, ordem int NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_etapa_codigo ON integrarp.jornada_etapa(jornada_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_progresso_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_id uuid NOT NULL, percentual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_progresso_usuario ON integrarp.jornada_progresso_usuario(tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, prioridade text NOT NULL DEFAULT 'media', rota_web text NOT NULL, motivo text NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_acao_tenant_codigo ON integrarp.jornada_acao_recomendada(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.template_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NOT NULL, status text NOT NULL DEFAULT 'disponivel', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_template_operacional_tenant_codigo ON integrarp.template_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.atividade_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, modulo text NOT NULL, rota_web text NOT NULL, rota_api text NULL, icone text NULL, ordem int NOT NULL DEFAULT 0, perfil_recomendado text NULL, status text NOT NULL DEFAULT 'funcional', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_atividade_operacional_tenant_codigo ON integrarp.atividade_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;

-- =====================================================
-- V1.9 - SEED DEMO FUNCIONAL COMPLETO
-- =====================================================
INSERT INTO integrarp.tenant (slug,nome,metadata_json) VALUES ('demo','Demo IntegraRP','{"demo":true,"versao":"v1.9"}'::jsonb)
ON CONFLICT (slug) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, metadata_json=EXCLUDED.metadata_json;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.permissao (tenant_id,codigo,descricao)
SELECT t.tenant_id, p.codigo, p.codigo FROM t CROSS JOIN (VALUES
('customers.view'),('customers.create'),('customers.update'),('products.view'),('products.create'),('inventory.view'),('inventory.entry'),('orders.view'),('orders.create'),('orders.confirm'),('tasks.view'),('tasks.claim'),('tasks.complete'),('billing.view'),('billing.create'),('outbox.view'),('outbox.process'),('dashboard.view'),('journey.view'),('templates.view'),('templates.install'),('activities.view')) p(codigo)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.perfil (tenant_id,nome,permissoes_json)
SELECT t.tenant_id, v.nome, (SELECT jsonb_agg(codigo ORDER BY codigo) FROM integrarp.permissao WHERE tenant_id=t.tenant_id) FROM t CROSS JOIN (VALUES ('Administrador'),('Gestor'),('Vendas'),('Operador'),('Financeiro'),('Logística')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET permissoes_json=EXCLUDED.permissoes_json;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.usuario (tenant_id,email,nome,perfil)
SELECT t.tenant_id, v.email, v.nome, v.perfil FROM t CROSS JOIN (VALUES
('admin@demo.integrarp.local','Admin Demo','Administrador'),('gestor@demo.integrarp.local','Gestor Demo','Gestor'),('vendedor@demo.integrarp.local','Vendedor Demo','Vendas'),('operador@demo.integrarp.local','Operador Demo','Operador'),('financeiro@demo.integrarp.local','Financeiro Demo','Financeiro'),('logistica@demo.integrarp.local','Logística Demo','Logística')) v(email,nome,perfil)
ON CONFLICT (tenant_id,email) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, perfil=EXCLUDED.perfil;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.setor (tenant_id,nome) SELECT t.tenant_id, nome FROM t CROSS JOIN (VALUES ('Administração'),('Comercial'),('Estoque'),('Logística'),('Financeiro')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.cliente (tenant_id,nome,documento,email) SELECT t.tenant_id,nome,doc,email FROM t CROSS JOIN (VALUES ('Cliente Demo Atacado','00000000000191','atacado@demo.local'),('Cliente Demo Varejo','00000000000272','varejo@demo.local'),('Cliente Demo Interior','00000000000353','interior@demo.local')) v(nome,doc,email)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET documento=EXCLUDED.documento,email=EXCLUDED.email,status='ativo';
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_contato (tenant_id,cliente_id,nome,email,telefone) SELECT tenant_id,cliente_id,'Contato principal '||nome,coalesce((SELECT email FROM integrarp.cliente cc WHERE cc.id=c.cliente_id),'contato@demo.local'),'11999990000' FROM c
ON CONFLICT (cliente_id,nome) WHERE excluido_em IS NULL DO UPDATE SET email=EXCLUDED.email;
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_endereco (tenant_id,cliente_id,logradouro,cidade,uf) SELECT tenant_id,cliente_id,'Rua Demo, 100','São Paulo','SP' FROM c
ON CONFLICT (cliente_id,logradouro) WHERE excluido_em IS NULL DO UPDATE SET cidade=EXCLUDED.cidade;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.produto_categoria (tenant_id,nome) SELECT t.tenant_id,nome FROM t CROSS JOIN (VALUES ('Bebidas'),('Alimentos'),('Diversos')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), cat AS (SELECT tenant_id,id,nome FROM integrarp.produto_categoria)
INSERT INTO integrarp.produto (tenant_id,categoria_id,sku,nome,estoque_minimo,estoque_atual)
SELECT t.tenant_id, cat.id, v.sku, v.nome, v.minimo, v.saldo FROM t CROSS JOIN (VALUES ('DEMO-A','Produto Demo A','Bebidas',10,120),('DEMO-B','Produto Demo B','Alimentos',5,80),('DEMO-CRIT','Produto Demo Crítico','Diversos',20,3)) v(sku,nome,categoria,minimo,saldo) JOIN cat ON cat.tenant_id=t.tenant_id AND cat.nome=v.categoria
ON CONFLICT (tenant_id,sku) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, estoque_minimo=EXCLUDED.estoque_minimo, estoque_atual=EXCLUDED.estoque_atual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.estoque_local (tenant_id,codigo,nome) SELECT t.tenant_id,codigo,nome FROM t CROSS JOIN (VALUES ('principal','Estoque Principal'),('expedicao','Estoque Expedição')) v(codigo,nome)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH p AS (SELECT p.tenant_id,p.id produto_id,p.estoque_atual,l.id local_id FROM integrarp.produto p JOIN integrarp.estoque_local l ON l.tenant_id=p.tenant_id AND l.codigo='principal' WHERE p.sku LIKE 'DEMO-%')
INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT tenant_id,produto_id,local_id,'entrada',estoque_atual,estoque_atual,'{"seed":"v1.9"}'::jsonb FROM p WHERE NOT EXISTS (SELECT 1 FROM integrarp.estoque_movimento m WHERE m.produto_id=p.produto_id AND m.metadata_json->>'seed'='v1.9');

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT * FROM integrarp.cliente WHERE nome='Cliente Demo Atacado')
INSERT INTO integrarp.pedido (tenant_id,cliente_id,numero,status,valor_total) SELECT t.tenant_id,c.id,v.numero,v.status,v.valor FROM t,c CROSS JOIN (VALUES ('PED-DEMO-001','rascunho',100),('PED-DEMO-002','confirmado',200),('PED-DEMO-003','aguardando_separacao',150),('PED-DEMO-004','faturavel',300)) v(numero,status,valor)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%'), prod AS (SELECT * FROM integrarp.produto WHERE sku='DEMO-A')
INSERT INTO integrarp.pedido_item (tenant_id,pedido_id,produto_id,quantidade,valor_unitario,valor_total) SELECT ped.tenant_id,ped.id,prod.id,2,50,100 FROM ped JOIN prod ON prod.tenant_id=ped.tenant_id
ON CONFLICT (pedido_id,produto_id) WHERE excluido_em IS NULL DO UPDATE SET quantidade=EXCLUDED.quantidade,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%')
INSERT INTO integrarp.tarefa_operacional (tenant_id,pedido_id,codigo,titulo,status,vencimento_em,responsavel_email)
SELECT tenant_id,id,'TASK-'||numero, CASE status WHEN 'aguardando_separacao' THEN 'Separar pedido' WHEN 'faturavel' THEN 'Faturar pedido' ELSE 'Acompanhar pedido' END, CASE numero WHEN 'PED-DEMO-001' THEN 'pendente' WHEN 'PED-DEMO-002' THEN 'concluida' ELSE 'pendente' END, CASE numero WHEN 'PED-DEMO-003' THEN now()-interval '1 day' ELSE now()+interval '2 days' END, 'operador@demo.integrarp.local' FROM ped
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,vencimento_em=EXCLUDED.vencimento_em;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero='PED-DEMO-004') INSERT INTO integrarp.fatura (tenant_id,pedido_id,numero,status,valor_total) SELECT tenant_id,id,'FAT-DEMO-001','emitida',valor_total FROM ped
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH f AS (SELECT * FROM integrarp.fatura WHERE numero='FAT-DEMO-001')
INSERT INTO integrarp.titulo_financeiro (tenant_id,fatura_id,numero,valor,vencimento,status,boleto_fake_linha_digitavel) SELECT tenant_id,id,v.numero,valor_total,v.vencimento,v.status,v.boleto FROM f CROSS JOIN (VALUES ('TIT-DEMO-001',CURRENT_DATE + 10,'aberto','34191.79001 01043.510047 91020.150008 8 90000000030000'),('TIT-DEMO-002',CURRENT_DATE - 5,'vencido','34191.79001 01043.510047 91020.150008 8 90000000015000')) v(numero,vencimento,status,boleto)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,boleto_fake_linha_digitavel=EXCLUDED.boleto_fake_linha_digitavel;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.outbox_evento (tenant_id,tipo,payload_json,status,tentativas,erro) SELECT t.tenant_id,tipo,jsonb_build_object('demo',true,'tipo',tipo),status,tentativas,erro FROM t CROSS JOIN (VALUES ('demo.pendente','pendente',0,NULL),('demo.processado','processado',1,NULL),('demo.erro','erro',2,'Falha fake para retry')) v(tipo,status,tentativas,erro)
ON CONFLICT (tenant_id,tipo,status) WHERE excluido_em IS NULL DO UPDATE SET tentativas=EXCLUDED.tentativas,erro=EXCLUDED.erro;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_usuario (tenant_id,codigo,titulo) SELECT tenant_id,'primeiros-passos','Jornada primeiros passos' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos') INSERT INTO integrarp.jornada_etapa (tenant_id,jornada_id,codigo,titulo,ordem,status) SELECT tenant_id,id,codigo,titulo,ordem,status FROM j CROSS JOIN (VALUES ('cliente','Criar cliente',1,'concluida'),('produto','Criar produto',2,'concluida'),('estoque','Registrar estoque',3,'concluida'),('pedido','Criar pedido',4,'concluida'),('faturamento','Faturar',5,'pendente')) v(codigo,titulo,ordem,status)
ON CONFLICT (jornada_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos'), u AS (SELECT * FROM integrarp.usuario WHERE email='admin@demo.integrarp.local') INSERT INTO integrarp.jornada_progresso_usuario (tenant_id,usuario_id,jornada_id,percentual) SELECT j.tenant_id,u.id,j.id,80 FROM j,u
ON CONFLICT (tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL DO UPDATE SET percentual=EXCLUDED.percentual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_acao_recomendada (tenant_id,codigo,titulo,descricao,rota_web,motivo) SELECT t.tenant_id,'acompanhar-dashboard','Acompanhar dashboard','Fluxo demo carregado com dados reais.','/dashboard','seed v1.9' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.template_operacional (tenant_id,codigo,nome,descricao) SELECT t.tenant_id,codigo,nome,descricao FROM t CROSS JOIN (VALUES ('pedido-faturamento','Pedido ao Faturamento','Fluxo completo pedido ao faturamento'),('separacao-pedido','Separação de Pedido','Checklist de separação'),('entrega-pod','Entrega com POD','Entrega com evidência'),('cobranca-vencido','Cobrança de Título Vencido','Cobrança operacional')) v(codigo,nome,descricao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome,descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.atividade_operacional (tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil_recomendado,status,metadata_json) SELECT t.tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,jsonb_build_object('permissao',permissao) FROM t CROSS JOIN (VALUES
('cadastrar-cliente','Cadastrar cliente','Criar cliente demo ou real','Comercial','/customers','/api/customers','users',10,'Vendas','funcional','customers.create'),('cadastrar-produto','Cadastrar produto','Criar produto comercial','Estoque','/products','/api/products','box',20,'Operador','funcional','products.create'),('entrada-estoque','Registrar entrada de estoque','Atualizar saldo real','Estoque','/inventory','/api/inventory/entries','warehouse',30,'Operador','funcional','inventory.entry'),('criar-pedido','Criar pedido','Gerar pedido com itens','Pedidos','/orders','/api/orders','cart',40,'Vendas','funcional','orders.create'),('confirmar-pedido','Confirmar pedido','Confirmar pedido em rascunho','Pedidos','/orders','/api/orders/{id}/confirm','check',50,'Vendas','funcional','orders.confirm'),('minhas-tarefas','Ver minhas tarefas','Listar tarefas pendentes','Tarefas','/tasks/my','/api/tasks/my','tasks',60,'Operador','funcional','tasks.view'),('concluir-tarefa','Concluir tarefa','Finalizar tarefa operacional','Tarefas','/tasks/my','/api/tasks/{id}/complete','done',70,'Operador','funcional','tasks.complete'),('gerar-fatura','Gerar fatura','Faturar pedido','Financeiro','/billing/invoices','/api/billing/invoices','invoice',80,'Financeiro','funcional','billing.create'),('gerar-titulo','Gerar título','Criar título financeiro','Financeiro','/billing/titles','/api/billing/financial-titles','money',90,'Financeiro','funcional','billing.create'),('gerar-boleto-fake','Gerar boleto fake','Criar linha digitável fake','Financeiro','/billing/titles','/api/billing/financial-titles/{id}/fake-slip','barcode',100,'Financeiro','funcional','billing.create'),('processar-outbox','Processar outbox','Processar pendências Connect','Connect','/connect/outbox','/api/connect/outbox/process','send',110,'Administrador','funcional','outbox.process'),('ver-dashboard','Ver dashboard','Acompanhar KPIs reais','Dashboard','/dashboard','/api/dashboard','chart',120,'Gestor','funcional','dashboard.view'),('instalar-template','Instalar template','Instalar pacote operacional','Templates','/templates','/api/operational-templates','template',130,'Administrador','funcional','templates.install'),('ver-jornada','Ver jornada','Continuar onboarding','Jornada','/journey/what-to-do-now','/api/journey/what-to-do-now','map',140,'Gestor','funcional','journey.view')) v(codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,permissao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo,descricao=EXCLUDED.descricao,status=EXCLUDED.status,metadata_json=EXCLUDED.metadata_json;

CREATE OR REPLACE VIEW integrarp.vw_v19_o_que_fazer_agora AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT t.tenant_id, (SELECT count(*) FROM integrarp.cliente WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) clientes, (SELECT count(*) FROM integrarp.produto WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) produtos, (SELECT count(*) FROM integrarp.estoque_movimento WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) estoque, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) pedidos, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND status='rascunho' AND excluido_em IS NULL) rascunhos, (SELECT count(*) FROM integrarp.tarefa_operacional WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) tarefas, (SELECT count(*) FROM integrarp.fatura WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) faturas, (SELECT count(*) FROM integrarp.titulo_financeiro WHERE tenant_id=t.tenant_id AND boleto_fake_linha_digitavel IS NOT NULL AND excluido_em IS NULL) boletos, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) outbox_pendente, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='erro' AND excluido_em IS NULL) outbox_erro FROM t)
SELECT tenant_id,
CASE WHEN clientes=0 THEN 'criar-primeiro-cliente' WHEN produtos=0 THEN 'criar-primeiro-produto' WHEN estoque=0 THEN 'registrar-estoque' WHEN pedidos=0 THEN 'criar-pedido' WHEN rascunhos>0 THEN 'confirmar-pedido' WHEN tarefas>0 THEN 'concluir-tarefa' WHEN faturas=0 THEN 'gerar-fatura' WHEN boletos=0 THEN 'gerar-boleto-fake' WHEN outbox_pendente>0 THEN 'processar-outbox' WHEN outbox_erro>0 THEN 'reprocessar-outbox' ELSE 'acompanhar-dashboard' END AS codigo,
CASE WHEN clientes=0 THEN 'Criar primeiro cliente' WHEN produtos=0 THEN 'Criar primeiro produto' WHEN estoque=0 THEN 'Registrar estoque' WHEN pedidos=0 THEN 'Criar pedido' WHEN rascunhos>0 THEN 'Confirmar pedido' WHEN tarefas>0 THEN 'Concluir tarefa pendente' WHEN faturas=0 THEN 'Gerar fatura' WHEN boletos=0 THEN 'Gerar boleto fake' WHEN outbox_pendente>0 THEN 'Processar outbox' WHEN outbox_erro>0 THEN 'Reprocessar outbox' ELSE 'Acompanhar dashboard' END AS titulo,
'dados reais do banco'::text AS detalhe,
CASE WHEN clientes=0 THEN '/customers' WHEN produtos=0 THEN '/products' WHEN estoque=0 THEN '/inventory' WHEN pedidos=0 THEN '/orders' WHEN rascunhos>0 THEN '/orders' WHEN tarefas>0 THEN '/tasks/my' WHEN faturas=0 THEN '/billing/invoices' WHEN boletos=0 THEN '/billing/titles' WHEN outbox_pendente>0 OR outbox_erro>0 THEN '/connect/outbox' ELSE '/dashboard' END AS rota_web
FROM c;

CREATE OR REPLACE VIEW integrarp.vw_v19_demo_funcional_status AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
SELECT 'tenant_demo' check_codigo,'Tenant demo existe' check_titulo, CASE WHEN EXISTS(SELECT 1 FROM t) THEN 'ok' ELSE 'erro' END status, 'slug demo' detalhe, 'criar tenant demo' proxima_acao
UNION ALL SELECT 'usuarios_demo','Usuários demo existem',CASE WHEN (SELECT count(*) FROM integrarp.usuario u JOIN t ON t.tenant_id=u.tenant_id WHERE u.email LIKE '%@demo.integrarp.local')>=6 THEN 'ok' ELSE 'erro' END,'6 usuários esperados','reaplicar seed'
UNION ALL SELECT 'atividades','Atividades existem',CASE WHEN (SELECT count(*) FROM integrarp.atividade_operacional a JOIN t ON t.tenant_id=a.tenant_id)>=14 THEN 'ok' ELSE 'erro' END,'14 atividades mínimas','reaplicar seed'
UNION ALL SELECT 'fluxo_operacional','Cliente produto estoque pedido tarefa faturamento outbox',CASE WHEN EXISTS(SELECT 1 FROM integrarp.pedido p JOIN t ON t.tenant_id=p.tenant_id) AND EXISTS(SELECT 1 FROM integrarp.fatura f JOIN t ON t.tenant_id=f.tenant_id) THEN 'ok' ELSE 'erro' END,'fluxo demo','executar demo';

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- Compatibilidade v1.8 preservada para testes de regressão
CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo text NOT NULL, objeto text NOT NULL, status text NOT NULL, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, area text NOT NULL, modulo text NOT NULL, status text NOT NULL, checks_json jsonb NOT NULL DEFAULT '{}'::jsonb, warnings_json jsonb NOT NULL DEFAULT '[]'::jsonb, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status ON integrarp.v18_screen_audit(tenant_id,modulo,status);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_v18_screen_audit_status') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT ck_v18_screen_audit_status CHECK (status IN ('ok','warning','error','funcional','pendente')); END IF; END $$;
DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit;
CREATE TRIGGER trg_v18_screen_audit_atualizado_em BEFORE UPDATE ON integrarp.v18_screen_audit FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional AS SELECT tenant_id, modulo, status, proxima_acao FROM integrarp.v18_screen_audit WHERE excluido_em IS NULL;
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- <<< 0021_v19_demo_funcional_inserts_telas_jornada.sql

-- >>> 0021_v19_fix_scriptcompleto_inserts_demo_jornada.sql
-- IntegraRP database complete idempotent script v1.9
CREATE SCHEMA IF NOT EXISTS integrarp;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em()
RETURNS trigger AS $$ BEGIN NEW.atualizado_em = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
CREATE TABLE IF NOT EXISTS integrarp.tenant (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), slug text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS slug text;
UPDATE integrarp.tenant SET slug = lower(replace(nome,' ','-')) WHERE slug IS NULL;
ALTER TABLE integrarp.tenant ALTER COLUMN slug SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tenant_slug ON integrarp.tenant(slug) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, email text NOT NULL, nome text NOT NULL, perfil text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_usuario_tenant_email ON integrarp.usuario(tenant_id,email) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.perfil (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, permissoes_json jsonb NOT NULL DEFAULT '[]'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_perfil_tenant_nome ON integrarp.perfil(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.permissao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, descricao text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_permissao_tenant_codigo ON integrarp.permissao(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.setor (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_setor_tenant_nome ON integrarp.setor(tenant_id,nome) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.cliente (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, documento text NULL, email text NULL, status text NOT NULL DEFAULT 'ativo', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_tenant_nome ON integrarp.cliente(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_contato (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, nome text NOT NULL, email text NULL, telefone text NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_contato_principal ON integrarp.cliente_contato(cliente_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.cliente_endereco (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NOT NULL, logradouro text NOT NULL, cidade text NOT NULL, uf text NOT NULL, principal boolean NOT NULL DEFAULT true, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_cliente_endereco_principal ON integrarp.cliente_endereco(cliente_id,logradouro) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.produto_categoria (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_categoria_tenant_nome ON integrarp.produto_categoria(tenant_id,nome) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.produto (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, categoria_id uuid NULL, sku text NOT NULL, nome text NOT NULL, status text NOT NULL DEFAULT 'ativo', estoque_minimo numeric NOT NULL DEFAULT 0, estoque_atual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_produto_tenant_sku ON integrarp.produto(tenant_id,sku) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_local (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_local_tenant_codigo ON integrarp.estoque_local(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.estoque_movimento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, produto_id uuid NOT NULL, local_id uuid NOT NULL, tipo text NOT NULL, quantidade numeric NOT NULL, saldo_apos numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);

CREATE TABLE IF NOT EXISTS integrarp.pedido (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, cliente_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_tenant_numero ON integrarp.pedido(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.pedido_item (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NOT NULL, produto_id uuid NOT NULL, quantidade numeric NOT NULL, valor_unitario numeric NOT NULL, valor_total numeric NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_pedido_item_produto ON integrarp.pedido_item(pedido_id,produto_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.tarefa_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, codigo text NOT NULL, titulo text NOT NULL, status text NOT NULL, vencimento_em timestamptz NULL, responsavel_email text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_tenant_codigo ON integrarp.tarefa_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.fatura (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, pedido_id uuid NULL, numero text NOT NULL, status text NOT NULL, valor_total numeric NOT NULL, emitida_em timestamptz NOT NULL DEFAULT now(), criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_fatura_tenant_numero ON integrarp.fatura(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.titulo_financeiro (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, fatura_id uuid NULL, numero text NOT NULL, valor numeric NOT NULL, vencimento date NOT NULL, status text NOT NULL, boleto_fake_linha_digitavel text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_titulo_financeiro_tenant_numero ON integrarp.titulo_financeiro(tenant_id,numero) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tipo text NOT NULL, payload_json jsonb NOT NULL DEFAULT '{}'::jsonb, status text NOT NULL DEFAULT 'pendente', tentativas int NOT NULL DEFAULT 0, max_tentativas int NOT NULL DEFAULT 3, proxima_tentativa_em timestamptz NULL, processado_em timestamptz NULL, erro text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_tipo_status ON integrarp.outbox_evento(tenant_id,tipo,status) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.outbox_processamento_log (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, outbox_evento_id uuid NULL, status text NOT NULL, detalhe text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.worker_checkpoint (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, ultimo_processamento_em timestamptz NOT NULL DEFAULT now(), status text NOT NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_worker_checkpoint_tenant_codigo ON integrarp.worker_checkpoint(tenant_id,codigo);

CREATE TABLE IF NOT EXISTS integrarp.jornada_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_usuario_tenant_codigo ON integrarp.jornada_usuario(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_etapa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, jornada_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, ordem int NOT NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_etapa_codigo ON integrarp.jornada_etapa(jornada_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_progresso_usuario (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, jornada_id uuid NOT NULL, percentual numeric NOT NULL DEFAULT 0, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_progresso_usuario ON integrarp.jornada_progresso_usuario(tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.jornada_acao_recomendada (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, prioridade text NOT NULL DEFAULT 'media', rota_web text NOT NULL, motivo text NULL, status text NOT NULL DEFAULT 'pendente', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jornada_acao_tenant_codigo ON integrarp.jornada_acao_recomendada(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.template_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NOT NULL, status text NOT NULL DEFAULT 'disponivel', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_template_operacional_tenant_codigo ON integrarp.template_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.atividade_operacional (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, titulo text NOT NULL, descricao text NOT NULL, modulo text NOT NULL, rota_web text NOT NULL, rota_api text NULL, icone text NULL, ordem int NOT NULL DEFAULT 0, perfil_recomendado text NULL, status text NOT NULL DEFAULT 'funcional', criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE UNIQUE INDEX IF NOT EXISTS ux_atividade_operacional_tenant_codigo ON integrarp.atividade_operacional(tenant_id,codigo) WHERE excluido_em IS NULL;

-- =====================================================
-- V1.9 - SEED DEMO FUNCIONAL COMPLETO
-- =====================================================
INSERT INTO integrarp.tenant (slug,nome,metadata_json) VALUES ('demo','Demo IntegraRP','{"demo":true,"versao":"v1.9"}'::jsonb)
ON CONFLICT (slug) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, metadata_json=EXCLUDED.metadata_json;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.permissao (tenant_id,codigo,descricao)
SELECT t.tenant_id, p.codigo, p.codigo FROM t CROSS JOIN (VALUES
('customers.view'),('customers.create'),('customers.update'),('products.view'),('products.create'),('inventory.view'),('inventory.entry'),('orders.view'),('orders.create'),('orders.confirm'),('tasks.view'),('tasks.claim'),('tasks.complete'),('billing.view'),('billing.create'),('outbox.view'),('outbox.process'),('dashboard.view'),('journey.view'),('templates.view'),('templates.install'),('activities.view')) p(codigo)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.perfil (tenant_id,nome,permissoes_json)
SELECT t.tenant_id, v.nome, (SELECT jsonb_agg(codigo ORDER BY codigo) FROM integrarp.permissao WHERE tenant_id=t.tenant_id) FROM t CROSS JOIN (VALUES ('Administrador'),('Gestor'),('Vendas'),('Operador'),('Financeiro'),('Logística')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET permissoes_json=EXCLUDED.permissoes_json;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.usuario (tenant_id,email,nome,perfil)
SELECT t.tenant_id, v.email, v.nome, v.perfil FROM t CROSS JOIN (VALUES
('admin@demo.integrarp.local','Admin Demo','Administrador'),('gestor@demo.integrarp.local','Gestor Demo','Gestor'),('vendedor@demo.integrarp.local','Vendedor Demo','Vendas'),('operador@demo.integrarp.local','Operador Demo','Operador'),('financeiro@demo.integrarp.local','Financeiro Demo','Financeiro'),('logistica@demo.integrarp.local','Logística Demo','Logística')) v(email,nome,perfil)
ON CONFLICT (tenant_id,email) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, perfil=EXCLUDED.perfil;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.setor (tenant_id,nome) SELECT t.tenant_id, nome FROM t CROSS JOIN (VALUES ('Administração'),('Comercial'),('Estoque'),('Logística'),('Financeiro')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.cliente (tenant_id,nome,documento,email) SELECT t.tenant_id,nome,doc,email FROM t CROSS JOIN (VALUES ('Cliente Demo Atacado','00000000000191','atacado@demo.local'),('Cliente Demo Varejo','00000000000272','varejo@demo.local'),('Cliente Demo Interior','00000000000353','interior@demo.local')) v(nome,doc,email)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET documento=EXCLUDED.documento,email=EXCLUDED.email,status='ativo';
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_contato (tenant_id,cliente_id,nome,email,telefone) SELECT tenant_id,cliente_id,'Contato principal '||nome,coalesce((SELECT email FROM integrarp.cliente cc WHERE cc.id=c.cliente_id),'contato@demo.local'),'11999990000' FROM c
ON CONFLICT (cliente_id,nome) WHERE excluido_em IS NULL DO UPDATE SET email=EXCLUDED.email;
WITH c AS (SELECT tenant_id,id cliente_id,nome FROM integrarp.cliente WHERE nome LIKE 'Cliente Demo%')
INSERT INTO integrarp.cliente_endereco (tenant_id,cliente_id,logradouro,cidade,uf) SELECT tenant_id,cliente_id,'Rua Demo, 100','São Paulo','SP' FROM c
ON CONFLICT (cliente_id,logradouro) WHERE excluido_em IS NULL DO UPDATE SET cidade=EXCLUDED.cidade;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.produto_categoria (tenant_id,nome) SELECT t.tenant_id,nome FROM t CROSS JOIN (VALUES ('Bebidas'),('Alimentos'),('Diversos')) v(nome)
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), cat AS (SELECT tenant_id,id,nome FROM integrarp.produto_categoria)
INSERT INTO integrarp.produto (tenant_id,categoria_id,sku,nome,estoque_minimo,estoque_atual)
SELECT t.tenant_id, cat.id, v.sku, v.nome, v.minimo, v.saldo FROM t CROSS JOIN (VALUES ('DEMO-A','Produto Demo A','Bebidas',10,120),('DEMO-B','Produto Demo B','Alimentos',5,80),('DEMO-CRIT','Produto Demo Crítico','Diversos',20,3)) v(sku,nome,categoria,minimo,saldo) JOIN cat ON cat.tenant_id=t.tenant_id AND cat.nome=v.categoria
ON CONFLICT (tenant_id,sku) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome, estoque_minimo=EXCLUDED.estoque_minimo, estoque_atual=EXCLUDED.estoque_atual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.estoque_local (tenant_id,codigo,nome) SELECT t.tenant_id,codigo,nome FROM t CROSS JOIN (VALUES ('principal','Estoque Principal'),('expedicao','Estoque Expedição')) v(codigo,nome)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome;
WITH p AS (SELECT p.tenant_id,p.id produto_id,p.estoque_atual,l.id local_id FROM integrarp.produto p JOIN integrarp.estoque_local l ON l.tenant_id=p.tenant_id AND l.codigo='principal' WHERE p.sku LIKE 'DEMO-%')
INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT tenant_id,produto_id,local_id,'entrada',estoque_atual,estoque_atual,'{"seed":"v1.9"}'::jsonb FROM p WHERE NOT EXISTS (SELECT 1 FROM integrarp.estoque_movimento m WHERE m.produto_id=p.produto_id AND m.metadata_json->>'seed'='v1.9');

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT * FROM integrarp.cliente WHERE nome='Cliente Demo Atacado')
INSERT INTO integrarp.pedido (tenant_id,cliente_id,numero,status,valor_total) SELECT t.tenant_id,c.id,v.numero,v.status,v.valor FROM t,c CROSS JOIN (VALUES ('PED-DEMO-001','rascunho',100),('PED-DEMO-002','confirmado',200),('PED-DEMO-003','aguardando_separacao',150),('PED-DEMO-004','faturavel',300)) v(numero,status,valor)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%'), prod AS (SELECT * FROM integrarp.produto WHERE sku='DEMO-A')
INSERT INTO integrarp.pedido_item (tenant_id,pedido_id,produto_id,quantidade,valor_unitario,valor_total) SELECT ped.tenant_id,ped.id,prod.id,2,50,100 FROM ped JOIN prod ON prod.tenant_id=ped.tenant_id
ON CONFLICT (pedido_id,produto_id) WHERE excluido_em IS NULL DO UPDATE SET quantidade=EXCLUDED.quantidade,valor_total=EXCLUDED.valor_total;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero LIKE 'PED-DEMO-%')
INSERT INTO integrarp.tarefa_operacional (tenant_id,pedido_id,codigo,titulo,status,vencimento_em,responsavel_email)
SELECT tenant_id,id,'TASK-'||numero, CASE status WHEN 'aguardando_separacao' THEN 'Separar pedido' WHEN 'faturavel' THEN 'Faturar pedido' ELSE 'Acompanhar pedido' END, CASE numero WHEN 'PED-DEMO-001' THEN 'pendente' WHEN 'PED-DEMO-002' THEN 'concluida' ELSE 'pendente' END, CASE numero WHEN 'PED-DEMO-003' THEN now()-interval '1 day' ELSE now()+interval '2 days' END, 'operador@demo.integrarp.local' FROM ped
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,vencimento_em=EXCLUDED.vencimento_em;
WITH ped AS (SELECT * FROM integrarp.pedido WHERE numero='PED-DEMO-004') INSERT INTO integrarp.fatura (tenant_id,pedido_id,numero,status,valor_total) SELECT tenant_id,id,'FAT-DEMO-001','emitida',valor_total FROM ped
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,valor_total=EXCLUDED.valor_total;
WITH f AS (SELECT * FROM integrarp.fatura WHERE numero='FAT-DEMO-001')
INSERT INTO integrarp.titulo_financeiro (tenant_id,fatura_id,numero,valor,vencimento,status,boleto_fake_linha_digitavel) SELECT tenant_id,id,v.numero,valor_total,v.vencimento,v.status,v.boleto FROM f CROSS JOIN (VALUES ('TIT-DEMO-001',CURRENT_DATE + 10,'aberto','34191.79001 01043.510047 91020.150008 8 90000000030000'),('TIT-DEMO-002',CURRENT_DATE - 5,'vencido','34191.79001 01043.510047 91020.150008 8 90000000015000')) v(numero,vencimento,status,boleto)
ON CONFLICT (tenant_id,numero) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status,boleto_fake_linha_digitavel=EXCLUDED.boleto_fake_linha_digitavel;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.outbox_evento (tenant_id,tipo,payload_json,status,tentativas,erro) SELECT t.tenant_id,tipo,jsonb_build_object('demo',true,'tipo',tipo),status,tentativas,erro FROM t CROSS JOIN (VALUES ('demo.pendente','pendente',0,NULL),('demo.processado','processado',1,NULL),('demo.erro','erro',2,'Falha fake para retry')) v(tipo,status,tentativas,erro)
ON CONFLICT (tenant_id,tipo,status) WHERE excluido_em IS NULL DO UPDATE SET tentativas=EXCLUDED.tentativas,erro=EXCLUDED.erro;

WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_usuario (tenant_id,codigo,titulo) SELECT tenant_id,'primeiros-passos','Jornada primeiros passos' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos') INSERT INTO integrarp.jornada_etapa (tenant_id,jornada_id,codigo,titulo,ordem,status) SELECT tenant_id,id,codigo,titulo,ordem,status FROM j CROSS JOIN (VALUES ('cliente','Criar cliente',1,'concluida'),('produto','Criar produto',2,'concluida'),('estoque','Registrar estoque',3,'concluida'),('pedido','Criar pedido',4,'concluida'),('faturamento','Faturar',5,'pendente')) v(codigo,titulo,ordem,status)
ON CONFLICT (jornada_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET status=EXCLUDED.status;
WITH j AS (SELECT * FROM integrarp.jornada_usuario WHERE codigo='primeiros-passos'), u AS (SELECT * FROM integrarp.usuario WHERE email='admin@demo.integrarp.local') INSERT INTO integrarp.jornada_progresso_usuario (tenant_id,usuario_id,jornada_id,percentual) SELECT j.tenant_id,u.id,j.id,80 FROM j,u
ON CONFLICT (tenant_id,usuario_id,jornada_id) WHERE excluido_em IS NULL DO UPDATE SET percentual=EXCLUDED.percentual;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.jornada_acao_recomendada (tenant_id,codigo,titulo,descricao,rota_web,motivo) SELECT t.tenant_id,'acompanhar-dashboard','Acompanhar dashboard','Fluxo demo carregado com dados reais.','/dashboard','seed v1.9' FROM t
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.template_operacional (tenant_id,codigo,nome,descricao) SELECT t.tenant_id,codigo,nome,descricao FROM t CROSS JOIN (VALUES ('pedido-faturamento','Pedido ao Faturamento','Fluxo completo pedido ao faturamento'),('separacao-pedido','Separação de Pedido','Checklist de separação'),('entrega-pod','Entrega com POD','Entrega com evidência'),('cobranca-vencido','Cobrança de Título Vencido','Cobrança operacional')) v(codigo,nome,descricao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome,descricao=EXCLUDED.descricao;
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo') INSERT INTO integrarp.atividade_operacional (tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil_recomendado,status,metadata_json) SELECT t.tenant_id,codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,jsonb_build_object('permissao',permissao) FROM t CROSS JOIN (VALUES
('cadastrar-cliente','Cadastrar cliente','Criar cliente demo ou real','Comercial','/customers','/api/customers','users',10,'Vendas','funcional','customers.create'),('cadastrar-produto','Cadastrar produto','Criar produto comercial','Estoque','/products','/api/products','box',20,'Operador','funcional','products.create'),('entrada-estoque','Registrar entrada de estoque','Atualizar saldo real','Estoque','/inventory','/api/inventory/entries','warehouse',30,'Operador','funcional','inventory.entry'),('criar-pedido','Criar pedido','Gerar pedido com itens','Pedidos','/orders','/api/orders','cart',40,'Vendas','funcional','orders.create'),('confirmar-pedido','Confirmar pedido','Confirmar pedido em rascunho','Pedidos','/orders','/api/orders/{id}/confirm','check',50,'Vendas','funcional','orders.confirm'),('minhas-tarefas','Ver minhas tarefas','Listar tarefas pendentes','Tarefas','/tasks/my','/api/tasks/my','tasks',60,'Operador','funcional','tasks.view'),('concluir-tarefa','Concluir tarefa','Finalizar tarefa operacional','Tarefas','/tasks/my','/api/tasks/{id}/complete','done',70,'Operador','funcional','tasks.complete'),('gerar-fatura','Gerar fatura','Faturar pedido','Financeiro','/billing/invoices','/api/billing/invoices','invoice',80,'Financeiro','funcional','billing.create'),('gerar-titulo','Gerar título','Criar título financeiro','Financeiro','/billing/titles','/api/billing/financial-titles','money',90,'Financeiro','funcional','billing.create'),('gerar-boleto-fake','Gerar boleto fake','Criar linha digitável fake','Financeiro','/billing/titles','/api/billing/financial-titles/{id}/fake-slip','barcode',100,'Financeiro','funcional','billing.create'),('processar-outbox','Processar outbox','Processar pendências Connect','Connect','/connect/outbox','/api/connect/outbox/process','send',110,'Administrador','funcional','outbox.process'),('ver-dashboard','Ver dashboard','Acompanhar KPIs reais','Dashboard','/dashboard','/api/dashboard','chart',120,'Gestor','funcional','dashboard.view'),('instalar-template','Instalar template','Instalar pacote operacional','Templates','/templates','/api/operational-templates','template',130,'Administrador','funcional','templates.install'),('ver-jornada','Ver jornada','Continuar onboarding','Jornada','/journey/what-to-do-now','/api/journey/what-to-do-now','map',140,'Gestor','funcional','journey.view')) v(codigo,titulo,descricao,modulo,rota_web,rota_api,icone,ordem,perfil,status,permissao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE SET titulo=EXCLUDED.titulo,descricao=EXCLUDED.descricao,status=EXCLUDED.status,metadata_json=EXCLUDED.metadata_json;

CREATE OR REPLACE VIEW integrarp.vw_v19_o_que_fazer_agora AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), c AS (SELECT t.tenant_id, (SELECT count(*) FROM integrarp.cliente WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) clientes, (SELECT count(*) FROM integrarp.produto WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) produtos, (SELECT count(*) FROM integrarp.estoque_movimento WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) estoque, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) pedidos, (SELECT count(*) FROM integrarp.pedido WHERE tenant_id=t.tenant_id AND status='rascunho' AND excluido_em IS NULL) rascunhos, (SELECT count(*) FROM integrarp.tarefa_operacional WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) tarefas, (SELECT count(*) FROM integrarp.fatura WHERE tenant_id=t.tenant_id AND excluido_em IS NULL) faturas, (SELECT count(*) FROM integrarp.titulo_financeiro WHERE tenant_id=t.tenant_id AND boleto_fake_linha_digitavel IS NOT NULL AND excluido_em IS NULL) boletos, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='pendente' AND excluido_em IS NULL) outbox_pendente, (SELECT count(*) FROM integrarp.outbox_evento WHERE tenant_id=t.tenant_id AND status='erro' AND excluido_em IS NULL) outbox_erro FROM t)
SELECT tenant_id,
CASE WHEN clientes=0 THEN 'criar-primeiro-cliente' WHEN produtos=0 THEN 'criar-primeiro-produto' WHEN estoque=0 THEN 'registrar-estoque' WHEN pedidos=0 THEN 'criar-pedido' WHEN rascunhos>0 THEN 'confirmar-pedido' WHEN tarefas>0 THEN 'concluir-tarefa' WHEN faturas=0 THEN 'gerar-fatura' WHEN boletos=0 THEN 'gerar-boleto-fake' WHEN outbox_pendente>0 THEN 'processar-outbox' WHEN outbox_erro>0 THEN 'reprocessar-outbox' ELSE 'acompanhar-dashboard' END AS codigo,
CASE WHEN clientes=0 THEN 'Criar primeiro cliente' WHEN produtos=0 THEN 'Criar primeiro produto' WHEN estoque=0 THEN 'Registrar estoque' WHEN pedidos=0 THEN 'Criar pedido' WHEN rascunhos>0 THEN 'Confirmar pedido' WHEN tarefas>0 THEN 'Concluir tarefa pendente' WHEN faturas=0 THEN 'Gerar fatura' WHEN boletos=0 THEN 'Gerar boleto fake' WHEN outbox_pendente>0 THEN 'Processar outbox' WHEN outbox_erro>0 THEN 'Reprocessar outbox' ELSE 'Acompanhar dashboard' END AS titulo,
'dados reais do banco'::text AS detalhe,
CASE WHEN clientes=0 THEN '/customers' WHEN produtos=0 THEN '/products' WHEN estoque=0 THEN '/inventory' WHEN pedidos=0 THEN '/orders' WHEN rascunhos>0 THEN '/orders' WHEN tarefas>0 THEN '/tasks/my' WHEN faturas=0 THEN '/billing/invoices' WHEN boletos=0 THEN '/billing/titles' WHEN outbox_pendente>0 OR outbox_erro>0 THEN '/connect/outbox' ELSE '/dashboard' END AS rota_web
FROM c;

CREATE OR REPLACE VIEW integrarp.vw_v19_demo_funcional_status AS
WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
SELECT 'tenant_demo' check_codigo,'Tenant demo existe' check_titulo, CASE WHEN EXISTS(SELECT 1 FROM t) THEN 'ok' ELSE 'erro' END status, 'slug demo' detalhe, 'criar tenant demo' proxima_acao
UNION ALL SELECT 'usuarios_demo','Usuários demo existem',CASE WHEN (SELECT count(*) FROM integrarp.usuario u JOIN t ON t.tenant_id=u.tenant_id WHERE u.email LIKE '%@demo.integrarp.local')>=6 THEN 'ok' ELSE 'erro' END,'6 usuários esperados','reaplicar seed'
UNION ALL SELECT 'atividades','Atividades existem',CASE WHEN (SELECT count(*) FROM integrarp.atividade_operacional a JOIN t ON t.tenant_id=a.tenant_id)>=14 THEN 'ok' ELSE 'erro' END,'14 atividades mínimas','reaplicar seed'
UNION ALL SELECT 'fluxo_operacional','Cliente produto estoque pedido tarefa faturamento outbox',CASE WHEN EXISTS(SELECT 1 FROM integrarp.pedido p JOIN t ON t.tenant_id=p.tenant_id) AND EXISTS(SELECT 1 FROM integrarp.fatura f JOIN t ON t.tenant_id=f.tenant_id) THEN 'ok' ELSE 'erro' END,'fluxo demo','executar demo';

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- Compatibilidade v1.8 preservada para testes de regressão
CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, modulo text NOT NULL, objeto text NOT NULL, status text NOT NULL, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, codigo text NOT NULL, nome text NOT NULL, descricao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, area text NOT NULL, modulo text NOT NULL, status text NOT NULL, checks_json jsonb NOT NULL DEFAULT '{}'::jsonb, warnings_json jsonb NOT NULL DEFAULT '[]'::jsonb, proxima_acao text NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NULL, excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status ON integrarp.v18_screen_audit(tenant_id,modulo,status);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_v18_screen_audit_status') THEN ALTER TABLE integrarp.v18_screen_audit ADD CONSTRAINT ck_v18_screen_audit_status CHECK (status IN ('ok','warning','error','funcional','pendente')); END IF; END $$;
DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit;
CREATE TRIGGER trg_v18_screen_audit_atualizado_em BEFORE UPDATE ON integrarp.v18_screen_audit FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();
CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional AS SELECT tenant_id, modulo, status, proxima_acao FROM integrarp.v18_screen_audit WHERE excluido_em IS NULL;
-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.

-- <<< 0021_v19_fix_scriptcompleto_inserts_demo_jornada.sql

-- >>> 0023_v113_consolidacao_funcional_maturidade.sql
-- v1.13 - Consolidação funcional, maturidade operacional e smoke E2E
CREATE TABLE IF NOT EXISTS integrarp.v113_functional_consolidation_check (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id),
    codigo text NOT NULL,
    modulo text NOT NULL,
    status text NOT NULL DEFAULT 'pendente',
    detalhe text NULL,
    proxima_acao text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_v113_functional_check_tenant_codigo_active
    ON integrarp.v113_functional_consolidation_check(tenant_id, codigo)
    WHERE excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_v113_functional_check_atualizado_em ON integrarp.v113_functional_consolidation_check;
CREATE TRIGGER trg_v113_functional_check_atualizado_em
BEFORE UPDATE ON integrarp.v113_functional_consolidation_check
FOR EACH ROW EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

WITH t AS (SELECT id AS tenant_id FROM integrarp.tenant WHERE slug = 'demo')
INSERT INTO integrarp.v113_functional_consolidation_check (tenant_id, codigo, modulo, status, detalhe, proxima_acao, metadata_json)
SELECT t.tenant_id, v.codigo, v.modulo, v.status, v.detalhe, v.proxima_acao, jsonb_build_object('versao','v1.13')
FROM t
CROSS JOIN (VALUES
    ('clientes-crud','customers','funcional','CRUD com listagem, detalhe, criação, edição e soft delete via repository.','Homologar tela /customers'),
    ('produtos-crud','products','funcional','CRUD com listagem, detalhe, criação, edição e soft delete via repository.','Homologar tela /products'),
    ('estoque-consultas','inventory','funcional','Saldo, movimentos e estoque crítico retornam dados reais do tenant.','Homologar /inventory/critical'),
    ('pedidos-fluxo','orders','funcional','Consulta, criação, itens, confirmação e cancelamento sem 501.','Executar smoke de pedidos'),
    ('tarefas-fluxo','tasks','funcional','Detalhe, assumir, comentar e concluir tarefa sem 501.','Executar smoke de tarefas')
) AS v(codigo, modulo, status, detalhe, proxima_acao)
ON CONFLICT (tenant_id, codigo) WHERE excluido_em IS NULL
DO UPDATE SET status = EXCLUDED.status, detalhe = EXCLUDED.detalhe, proxima_acao = EXCLUDED.proxima_acao, metadata_json = EXCLUDED.metadata_json, atualizado_em = now();

WITH t AS (SELECT id AS tenant_id FROM integrarp.tenant WHERE slug = 'demo')
INSERT INTO integrarp.template_operacional (tenant_id,codigo,nome,descricao)
SELECT t.tenant_id,codigo,nome,descricao
FROM t
CROSS JOIN (VALUES
    ('visita-comercial','Visita Comercial','Roteiro comercial com atividade recomendada e acompanhamento.'),
    ('devolucao','Devolução','Fluxo operacional de devolução com triagem e ação financeira.'),
    ('registro-avaria','Registro de Avaria','Registro de avaria com evidência e próxima ação operacional.')
) v(codigo,nome,descricao)
ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL
DO UPDATE SET nome=EXCLUDED.nome, descricao=EXCLUDED.descricao, atualizado_em=now();

CREATE OR REPLACE VIEW integrarp.vw_v113_consolidacao_funcional_status AS
SELECT tenant_id, codigo, modulo, status, detalhe, proxima_acao
FROM integrarp.v113_functional_consolidation_check
WHERE excluido_em IS NULL;

-- v1.20: registro manual em schema_migrations removido; Migration Runner/script completo registram checksums.

-- <<< 0023_v113_consolidacao_funcional_maturidade.sql

-- >>> 0024_v114_consolidacao_operacional_seguranca.sql
-- v1.14 - consolidação operacional e segurança real
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_custo numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.produto ADD COLUMN IF NOT EXISTS preco_venda numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS data_entrega_prevista timestamptz NULL;
ALTER TABLE integrarp.pedido ADD COLUMN IF NOT EXISTS desconto_total numeric NOT NULL DEFAULT 0;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS descricao text NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS sla_minutos integer NULL;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_comentario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tarefa_id uuid NOT NULL,
    author_user_id uuid NOT NULL,
    texto text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NULL,
    excluido_em timestamptz NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS integrarp.pedido_status_historico (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    motivo text NULL,
    usuario_id uuid NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_produto_tenant_sku_ativo ON integrarp.produto (tenant_id, sku) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_responsavel ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id, setor_id, status) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_comentario_tenant_tarefa ON integrarp.tarefa_comentario (tenant_id, tarefa_id) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_pedido_status_historico_tenant_pedido ON integrarp.pedido_status_historico (tenant_id, pedido_id, criado_em);

-- <<< 0024_v114_consolidacao_operacional_seguranca.sql

-- >>> 0025_v117_auth_tasks_mobile_persistence.sql
CREATE SCHEMA IF NOT EXISTS integrarp;
ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS slug text;
ALTER TABLE integrarp.tenant ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'ativo';
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'ativo';
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS ultimo_login_em timestamptz NULL;
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS tentativas_invalidas integer NOT NULL DEFAULT 0;
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS bloqueado_ate timestamptz NULL;
ALTER TABLE integrarp.usuario ADD COLUMN IF NOT EXISTS senha_hash text NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_v117_tenant_slug ON integrarp.tenant (lower(slug)) WHERE excluido_em IS NULL AND slug IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_v117_usuario_tenant_email ON integrarp.usuario (tenant_id, lower(email)) WHERE excluido_em IS NULL;
CREATE TABLE IF NOT EXISTS integrarp.usuario_credencial (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), password_hash text NOT NULL, password_changed_at timestamptz NOT NULL DEFAULT now(), force_change boolean NOT NULL DEFAULT false, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, UNIQUE (tenant_id, usuario_id));
CREATE TABLE IF NOT EXISTS integrarp.perfil_permissao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), perfil_id uuid NOT NULL REFERENCES integrarp.perfil(id), permissao_id uuid NOT NULL REFERENCES integrarp.permissao(id), criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, UNIQUE (tenant_id, perfil_id, permissao_id));
CREATE TABLE IF NOT EXISTS integrarp.auth_sessao (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), device_id text NULL, device_name text NULL, criado_em timestamptz NOT NULL DEFAULT now(), expires_at timestamptz NOT NULL, revoked_at timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.auth_refresh_token (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), sessao_id uuid NOT NULL REFERENCES integrarp.auth_sessao(id), token_hash text NOT NULL, family_id uuid NOT NULL, expires_at timestamptz NOT NULL, criado_em timestamptz NOT NULL DEFAULT now(), used_at timestamptz NULL, revoked_at timestamptz NULL, replaced_by_hash text NULL, UNIQUE(token_hash));
CREATE TABLE IF NOT EXISTS integrarp.auth_login_tentativa (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NULL, usuario_id uuid NULL, email_normalizado text NULL, sucesso boolean NOT NULL, reason text NOT NULL, ip text NULL, criado_em timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS integrarp.auth_password_reset (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), token_hash text NOT NULL, expires_at timestamptz NOT NULL, used_at timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), UNIQUE(token_hash));
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS iniciado_em timestamptz NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS concluido_em timestamptz NULL;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb;
CREATE TABLE IF NOT EXISTS integrarp.tarefa_evidencia (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), tarefa_id uuid NOT NULL, usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), storage_key text NULL, original_filename text NULL, content_type text NULL, tamanho_bytes bigint NULL, sha256 text NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL, metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE TABLE IF NOT EXISTS integrarp.mobile_sync_queue (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), device_id text NOT NULL, tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NOT NULL REFERENCES integrarp.usuario(id), idempotency_key text NOT NULL, entidade text NOT NULL, entidade_id uuid NULL, operacao text NOT NULL, payload_json jsonb NOT NULL, versao_cliente text NULL, status text NOT NULL DEFAULT 'pendente', tentativas integer NOT NULL DEFAULT 0, proxima_tentativa_em timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), processado_em timestamptz NULL, erro_codigo text NULL, erro_resumo text NULL, UNIQUE (tenant_id, usuario_id, device_id, idempotency_key));
CREATE TABLE IF NOT EXISTS integrarp.auditoria_evento (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL REFERENCES integrarp.tenant(id), usuario_id uuid NULL, entidade text NOT NULL, entidade_id uuid NULL, acao text NOT NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb);
CREATE INDEX IF NOT EXISTS ix_v117_refresh_session ON integrarp.auth_refresh_token (sessao_id, revoked_at, expires_at);
CREATE INDEX IF NOT EXISTS ix_v117_tasks_my ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id, status, vencimento_em) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_v117_sync_status ON integrarp.mobile_sync_queue (tenant_id, usuario_id, device_id, status, proxima_tentativa_em);

-- <<< 0025_v117_auth_tasks_mobile_persistence.sql

-- >>> 0026_v118_auth_ux_task_hardening.sql
CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS tentativas_invalidas integer NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS bloqueado_ate timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario_credencial ADD COLUMN IF NOT EXISTS security_stamp text NOT NULL DEFAULT gen_random_uuid()::text;

ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS ip text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS user_agent text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS correlation_id text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS revoked_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS revocation_reason text NULL;
ALTER TABLE IF EXISTS integrarp.auth_sessao ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS family_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS replaced_by_hash text NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS used_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS revoked_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS revocation_reason text NULL;
ALTER TABLE IF EXISTS integrarp.auth_refresh_token ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NOT NULL DEFAULT now();
UPDATE integrarp.auth_refresh_token SET family_id = COALESCE(family_id, sessao_id) WHERE family_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_auth_refresh_token_hash ON integrarp.auth_refresh_token (token_hash);
CREATE INDEX IF NOT EXISTS ix_auth_refresh_token_family ON integrarp.auth_refresh_token (family_id) WHERE revoked_at IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.auth_password_reset (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, usuario_id uuid NOT NULL, token_hash text NOT NULL,
    expires_at timestamptz NOT NULL, consumed_at timestamptz NULL, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_auth_password_reset_usuario FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_auth_password_reset_hash ON integrarp.auth_password_reset (token_hash);
CREATE INDEX IF NOT EXISTS ix_auth_password_reset_usuario ON integrarp.auth_password_reset (tenant_id, usuario_id) WHERE consumed_at IS NULL AND excluido_em IS NULL;

ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS cancelamento_motivo text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS formulario_schema_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_schema_json jsonb NOT NULL DEFAULT '[]'::jsonb;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_historico (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NULL,
    status_anterior text NULL, status_novo text NOT NULL, motivo text NULL, correlation_id text NULL, criado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_tarefa_historico_tarefa FOREIGN KEY (tenant_id, tarefa_id) REFERENCES integrarp.tarefa_operacional (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_tarefa_historico_tarefa ON integrarp.tarefa_historico (tenant_id, tarefa_id, criado_em DESC) WHERE excluido_em IS NULL;

CREATE TABLE IF NOT EXISTS integrarp.tarefa_arquivo_evidencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(), tenant_id uuid NOT NULL, tarefa_id uuid NOT NULL, usuario_id uuid NOT NULL,
    nome_original text NOT NULL, nome_fisico text NOT NULL, content_type text NOT NULL, extensao text NOT NULL, tamanho_bytes bigint NOT NULL, sha256 text NOT NULL,
    storage_provider text NOT NULL DEFAULT 'local', metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb, criado_em timestamptz NOT NULL DEFAULT now(), atualizado_em timestamptz NOT NULL DEFAULT now(), excluido_em timestamptz NULL,
    CONSTRAINT fk_tarefa_arquivo_tarefa FOREIGN KEY (tenant_id, tarefa_id) REFERENCES integrarp.tarefa_operacional (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_tarefa_arquivo_tarefa ON integrarp.tarefa_arquivo_evidencia (tenant_id, tarefa_id) WHERE excluido_em IS NULL;

-- <<< 0026_v118_auth_ux_task_hardening.sql

-- >>> 0027_v119_postgresql_standalone_flow_persistido.sql
-- IntegraRP v1.19 - PostgreSQL standalone e compatibilidade Flow/Auth
-- Migration aditiva e idempotente; transação controlada pelo Migration Runner.

ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS consumed_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS atualizado_em timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.auth_password_reset ADD COLUMN IF NOT EXISTS excluido_em timestamptz NULL;

DO $$
BEGIN
  IF EXISTS (
      SELECT 1 FROM information_schema.columns
       WHERE table_schema = 'integrarp'
         AND table_name = 'auth_password_reset'
         AND column_name = 'used_at'
  ) THEN
    EXECUTE 'UPDATE integrarp.auth_password_reset SET consumed_at = used_at WHERE consumed_at IS NULL AND used_at IS NOT NULL';
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_auth_password_reset_active
    ON integrarp.auth_password_reset (tenant_id, usuario_id, expires_at)
    WHERE consumed_at IS NULL AND excluido_em IS NULL;

DROP TRIGGER IF EXISTS trg_auth_password_reset_atualizado_em ON integrarp.auth_password_reset;
CREATE TRIGGER trg_auth_password_reset_atualizado_em
BEFORE UPDATE ON integrarp.auth_password_reset
FOR EACH ROW
EXECUTE FUNCTION integrarp.fn_set_atualizado_em();

ALTER TABLE IF EXISTS integrarp.processo_instancia ADD COLUMN IF NOT EXISTS tarefa_operacional_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_definicao_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_versao_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_instancia_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS processo_elemento_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS origem_tipo text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS origem_id uuid NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS idempotency_key text NULL;
ALTER TABLE IF EXISTS integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
CREATE UNIQUE INDEX IF NOT EXISTS ux_tarefa_operacional_idempotency ON integrarp.tarefa_operacional (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_processo_instancia ON integrarp.tarefa_operacional (tenant_id, processo_instancia_id) WHERE processo_instancia_id IS NOT NULL;

-- <<< 0027_v119_postgresql_standalone_flow_persistido.sql

-- >>> 0028_v122_release_candidate_core_real.sql
-- v1.22 release candidate hardening marker.
-- This migration is intentionally additive and idempotent. It records the
-- release-candidate database contract without changing existing data because
-- the runtime schema objects required by authentication, tasks, Flow, outbox
-- and audit already exist in the consolidated script at the v1.21 base.
CREATE TABLE IF NOT EXISTS integrarp.release_candidate_evidencia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    versao text NOT NULL,
    base_sha text NOT NULL,
    status text NOT NULL,
    observacao text NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,
    CONSTRAINT ck_release_candidate_evidencia_status CHECK (status IN ('parcial','bloqueado','homologacao','aprovado')),
    CONSTRAINT uq_release_candidate_evidencia_versao UNIQUE (versao)
);

INSERT INTO integrarp.release_candidate_evidencia (versao, base_sha, status, observacao)
VALUES ('v1.22', '1bddde90549e062fd4514fe61eb89b93ab690122', 'parcial', 'Registro idempotente da preparação do release candidate v1.22; evidências detalhadas em docs/v1.22-*.md.')
ON CONFLICT (versao) DO UPDATE SET
    base_sha = EXCLUDED.base_sha,
    status = EXCLUDED.status,
    observacao = EXCLUDED.observacao,
    atualizado_em = now(),
    row_version = integrarp.release_candidate_evidencia.row_version + 1;

CREATE INDEX IF NOT EXISTS ix_release_candidate_evidencia_status
    ON integrarp.release_candidate_evidencia (status, criado_em DESC);

-- <<< 0028_v122_release_candidate_core_real.sql

-- >>> 0029_v123_core_operacional_real.sql
-- IntegraRP v1.23 - hardening operacional real.
-- Migration aditiva e idempotente; transação controlada pelo Migration Runner/script completo.

ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS lockout_until timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS failed_login_count integer NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS last_failed_login_at timestamptz NULL;
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS security_stamp uuid NOT NULL DEFAULT gen_random_uuid();
ALTER TABLE IF EXISTS integrarp.usuario ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'usuario')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE connamespace = 'integrarp'::regnamespace AND conname = 'uq_usuario_tenant_id_id') THEN
        ALTER TABLE integrarp.usuario
            ADD CONSTRAINT uq_usuario_tenant_id_id UNIQUE (tenant_id, id);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS integrarp.auth_login_attempt (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NULL,
    usuario_id uuid NULL,
    tenant_slug text NULL,
    email_normalizado text NOT NULL,
    success boolean NOT NULL,
    failure_reason text NULL,
    ip_address inet NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_auth_login_attempt_lookup
    ON integrarp.auth_login_attempt (tenant_id, email_normalizado, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.auth_password_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NOT NULL,
    password_hash text NOT NULL,
    security_stamp uuid NOT NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_auth_password_history_usuario FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id)
);
CREATE INDEX IF NOT EXISTS ix_auth_password_history_usuario
    ON integrarp.auth_password_history (tenant_id, usuario_id, criado_em DESC);

ALTER TABLE IF EXISTS integrarp.cliente ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.produto ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS integrarp.pedido ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    locked_by text NOT NULL,
    correlation_id text NULL,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, job_name)
);

CREATE TABLE IF NOT EXISTS integrarp.worker_dead_letter (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    erro text NOT NULL,
    attempts integer NOT NULL DEFAULT 0,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_worker_dead_letter_tenant_job
    ON integrarp.worker_dead_letter (tenant_id, job_name, criado_em DESC);

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND COALESCE(p.status, '') NOT IN ('Entregue','Cancelado')), 0) AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional ta WHERE ta.tenant_id = t.id AND ta.excluido_em IS NULL AND ta.status NOT IN ('Concluida','Cancelada','concluida','cancelada') AND ta.vencimento_em < now()), 0) AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.processo_instancia pi WHERE pi.tenant_id = t.id AND COALESCE(pi.status, '') NOT IN ('Concluido','Cancelado')), 0) AS processos_ativos,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND COALESCE(oe.status, '') IN ('erro','falha')), 0) AS outbox_com_erro
FROM integrarp.tenant t
WHERE COALESCE(t.status, '') = 'ativo' AND t.excluido_em IS NULL;

-- <<< 0029_v123_core_operacional_real.sql

-- >>> 0030_v124_production_foundation_auth_ux.sql
-- IntegraRP v1.24 - fundação de produção, autenticação Web e UX
-- PostgreSQL 16; schema integrarp; migration idempotente e aditiva.

ALTER TABLE IF EXISTS integrarp.usuario
    ADD COLUMN IF NOT EXISTS ultima_tentativa_invalida_em timestamptz;

UPDATE integrarp.usuario
   SET tentativas_invalidas = GREATEST(COALESCE(tentativas_invalidas, 0), COALESCE(failed_login_count, 0))
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'failed_login_count')
   AND COALESCE(failed_login_count, 0) > COALESCE(tentativas_invalidas, 0);

UPDATE integrarp.usuario
   SET bloqueado_ate = lockout_until
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'lockout_until')
   AND lockout_until IS NOT NULL
   AND (bloqueado_ate IS NULL OR lockout_until > bloqueado_ate);

UPDATE integrarp.usuario
   SET ultima_tentativa_invalida_em = last_failed_login_at
 WHERE EXISTS (
       SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'integrarp' AND table_name = 'usuario' AND column_name = 'last_failed_login_at')
   AND last_failed_login_at IS NOT NULL
   AND ultima_tentativa_invalida_em IS NULL;

ALTER TABLE IF EXISTS integrarp.usuario_credencial
    ADD COLUMN IF NOT EXISTS security_stamp uuid NOT NULL DEFAULT gen_random_uuid();

CREATE TABLE IF NOT EXISTS integrarp.auth_login_tentativa (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid,
    usuario_id uuid,
    email_normalizado text NOT NULL,
    sucesso boolean NOT NULL DEFAULT false,
    ip text,
    user_agent text,
    motivo text,
    correlation_id text,
    criado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS reason text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_tentativa' AND column_name = 'reason') THEN
        UPDATE integrarp.auth_login_tentativa
           SET motivo = COALESCE(motivo, reason)
         WHERE motivo IS NULL AND reason IS NOT NULL;
        ALTER TABLE integrarp.auth_login_tentativa ALTER COLUMN reason DROP NOT NULL;
    END IF;
END $$;

INSERT INTO integrarp.auth_login_tentativa (id, tenant_id, usuario_id, email_normalizado, sucesso, ip, user_agent, motivo, correlation_id, criado_em)
SELECT a.id, a.tenant_id, a.usuario_id, a.email_normalizado, a.success, a.ip_address::text, NULL::text, a.failure_reason, a.correlation_id, a.criado_em
  FROM integrarp.auth_login_attempt a
 WHERE EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'auth_login_attempt' AND table_type = 'BASE TABLE')
   AND NOT EXISTS (SELECT 1 FROM integrarp.auth_login_tentativa t WHERE t.id = a.id);

CREATE INDEX IF NOT EXISTS ix_auth_login_tentativa_lookup
    ON integrarp.auth_login_tentativa (tenant_id, email_normalizado, criado_em DESC);

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'usuario')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_usuario_tenant_id_id') THEN
        ALTER TABLE integrarp.usuario
            ADD CONSTRAINT uq_usuario_tenant_id_id UNIQUE (tenant_id, id);
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'integrarp' AND table_name = 'auth_password_history')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_auth_password_history_usuario') THEN
        ALTER TABLE integrarp.auth_password_history
            ADD CONSTRAINT fk_auth_password_history_usuario
            FOREIGN KEY (tenant_id, usuario_id) REFERENCES integrarp.usuario (tenant_id, id);
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.processo_instancia fi WHERE fi.tenant_id = t.id AND lower(COALESCE(fi.status, '')) IN ('ativo','ativa','em_andamento','running')), 0)::integer AS processos_ativos,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;

-- <<< 0030_v124_production_foundation_auth_ux.sql

-- >>> 0031_v125_core_comercial_ux_operacional.sql
-- IntegraRP v1.25 - Core Comercial, UX Premium e Operação Intuitiva
-- PostgreSQL 16; schema integrarp; migration aditiva, idempotente.

ALTER TABLE IF EXISTS integrarp.auth_sessao
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS last_refreshed_at timestamptz;

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS correlation_id text;


CREATE TABLE IF NOT EXISTS integrarp.auditoria_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    usuario_id uuid NULL,
    entidade text NOT NULL,
    entidade_id uuid NULL,
    acao text NOT NULL,
    dados_json jsonb NULL,
    detalhes jsonb NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_auditoria_evento_tenant_criado
    ON integrarp.auditoria_evento (tenant_id, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.outbox_evento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    tipo text NULL,
    tipo_evento text NULL,
    canal text NULL,
    payload jsonb NULL,
    payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
    status text NOT NULL DEFAULT 'pendente',
    tentativas integer NOT NULL DEFAULT 0,
    max_tentativas integer NOT NULL DEFAULT 5,
    proxima_tentativa_em timestamptz NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now(),
    processado_em timestamptz NULL,
    erro text NULL,
    metadata_json jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_criado
    ON integrarp.outbox_evento (tenant_id, status, criado_em);

CREATE TABLE IF NOT EXISTS integrarp.worker_tenant_job_lock (
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    locked_until timestamptz NOT NULL,
    locked_by text NOT NULL DEFAULT 'integrarp-worker',
    correlation_id text NULL,
    atualizado_em timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, job_name)
);

CREATE TABLE IF NOT EXISTS integrarp.worker_dead_letter (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    job_name text NOT NULL,
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    erro text NOT NULL,
    attempts integer NOT NULL DEFAULT 0,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);

DO $$
BEGIN
    IF to_regclass('integrarp.v125_audit_evento') IS NOT NULL THEN
        INSERT INTO integrarp.auditoria_evento (id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em)
        SELECT id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em
          FROM integrarp.v125_audit_evento
        ON CONFLICT (id) DO NOTHING;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_audit_evento) THEN
            DROP TABLE integrarp.v125_audit_evento;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_outbox_evento') IS NOT NULL THEN
        INSERT INTO integrarp.outbox_evento (id, tenant_id, tipo, tipo_evento, payload, payload_json, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em)
        SELECT id, tenant_id, tipo, tipo, payload, payload, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em
          FROM integrarp.v125_outbox_evento
        ON CONFLICT (id) DO NOTHING;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_outbox_evento) THEN
            DROP TABLE integrarp.v125_outbox_evento;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_worker_lock') IS NOT NULL THEN
        INSERT INTO integrarp.worker_tenant_job_lock (tenant_id, job_name, locked_until, correlation_id, atualizado_em)
        SELECT tenant_id, job_name, locked_until, correlation_id, updated_at FROM integrarp.v125_worker_lock
        ON CONFLICT (tenant_id, job_name) DO UPDATE SET locked_until = EXCLUDED.locked_until, correlation_id = EXCLUDED.correlation_id, atualizado_em = EXCLUDED.atualizado_em;
        IF NOT EXISTS (SELECT 1 FROM integrarp.v125_worker_lock) THEN
            DROP TABLE integrarp.v125_worker_lock;
        END IF;
    END IF;
    IF to_regclass('integrarp.v125_dashboard_agregado') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM integrarp.v125_dashboard_agregado) THEN
        DROP TABLE integrarp.v125_dashboard_agregado;
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('aberto','em_andamento','andamento','processando','confirmado','em_separacao')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;

-- <<< 0031_v125_core_comercial_ux_operacional.sql

-- >>> 0032_v126_jornada_comercial_ux_premium.sql
-- IntegraRP v1.26 - Jornada Comercial Real, UX Premium e Homologação Verde
-- PostgreSQL 16; schema integrarp; migration aditiva, idempotente.

ALTER TABLE IF EXISTS integrarp.auth_login_tentativa
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS reason text,
    ADD COLUMN IF NOT EXISTS user_agent text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_tentativa' AND column_name = 'reason') THEN
        UPDATE integrarp.auth_login_tentativa
           SET motivo = COALESCE(motivo, reason)
         WHERE motivo IS NULL AND reason IS NOT NULL;
        ALTER TABLE integrarp.auth_login_tentativa ALTER COLUMN reason DROP NOT NULL;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'auth_login_attempt' AND column_name = 'failure_reason') THEN
        INSERT INTO integrarp.auth_login_tentativa (id, tenant_id, usuario_id, email_normalizado, sucesso, ip, user_agent, motivo, correlation_id, criado_em)
        SELECT a.id, a.tenant_id, a.usuario_id, a.email_normalizado, a.success, a.ip_address::text, NULL::text, a.failure_reason, a.correlation_id, a.criado_em
          FROM integrarp.auth_login_attempt a
         WHERE NOT EXISTS (SELECT 1 FROM integrarp.auth_login_tentativa t WHERE t.id = a.id);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_auth_login_tentativa_tenant_sucesso_criado
    ON integrarp.auth_login_tentativa (tenant_id, sucesso, criado_em DESC);

CREATE TABLE IF NOT EXISTS integrarp.pedido_historico_status (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL,
    pedido_id uuid NOT NULL,
    status_anterior text NULL,
    status_novo text NOT NULL,
    usuario_id uuid NULL,
    motivo text NULL,
    correlation_id text NULL,
    criado_em timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS integrarp.estoque_movimento
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

ALTER TABLE IF EXISTS integrarp.estoque_reserva
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text;

CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_movimento_idempotency
    ON integrarp.estoque_movimento (tenant_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS ux_estoque_reserva_idempotency
    ON integrarp.estoque_reserva (tenant_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('confirmado','em_separacao','separado','faturamento_pendente','aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.tarefa tf WHERE tf.tenant_id = t.id AND tf.prazo_em::date = CURRENT_DATE AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_para_hoje,
    COALESCE((SELECT count(*) FROM integrarp.estoque_saldo es JOIN integrarp.produto p ON p.tenant_id = es.tenant_id AND p.id = es.produto_id WHERE es.tenant_id = t.id AND COALESCE(es.quantidade_disponivel, es.quantidade, 0) <= COALESCE(p.estoque_minimo, 0)), 0)::integer AS estoque_critico,
    COALESCE((SELECT count(*) FROM integrarp.estoque_reserva er WHERE er.tenant_id = t.id AND lower(COALESCE(er.status, '')) IN ('pendente','reservado')), 0)::integer AS reservas_pendentes,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;

-- <<< 0032_v126_jornada_comercial_ux_premium.sql

COMMIT;


-- ============================================================================
-- Migration: 0033_v127_operacao_comercial_executavel.sql
-- ============================================================================
-- IntegraRP v1.27 - Operacao Comercial Executavel, UX Premium e Release Homologada
-- PostgreSQL 16; schema integrarp; migration aditiva e idempotente.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE IF EXISTS integrarp.auditoria_evento
    ADD COLUMN IF NOT EXISTS antes_json jsonb,
    ADD COLUMN IF NOT EXISTS depois_json jsonb,
    ADD COLUMN IF NOT EXISTS ip text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE IF EXISTS integrarp.outbox_evento
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS dead_letter_em timestamptz;

ALTER TABLE IF EXISTS integrarp.worker_tenant_job_lock
    ADD COLUMN IF NOT EXISTS started_at timestamptz,
    ADD COLUMN IF NOT EXISTS duration_ms bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS attempts integer NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.worker_dead_letter
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.pedido_historico_status
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS atualizado_em timestamptz,
    ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

ALTER TABLE IF EXISTS integrarp.estoque_movimento
    ADD COLUMN IF NOT EXISTS motivo text,
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.estoque_reserva
    ADD COLUMN IF NOT EXISTS usuario_id uuid,
    ADD COLUMN IF NOT EXISTS idempotency_key text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS integrarp.tarefa_operacional
    ADD COLUMN IF NOT EXISTS descricao text,
    ADD COLUMN IF NOT EXISTS setor text,
    ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid,
    ADD COLUMN IF NOT EXISTS prioridade text NOT NULL DEFAULT 'normal',
    ADD COLUMN IF NOT EXISTS sla_minutos integer,
    ADD COLUMN IF NOT EXISTS checklist_json jsonb NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS iniciado_em timestamptz,
    ADD COLUMN IF NOT EXISTS concluido_em timestamptz,
    ADD COLUMN IF NOT EXISTS cancelado_em timestamptz,
    ADD COLUMN IF NOT EXISTS motivo_cancelamento text,
    ADD COLUMN IF NOT EXISTS correlation_id text,
    ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_pedido ON integrarp.pedido_historico_status (tenant_id, pedido_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_tenant_data ON integrarp.pedido_historico_status (tenant_id, criado_em DESC);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_idempotency ON integrarp.outbox_evento (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_vencimento ON integrarp.tarefa_operacional (tenant_id, vencimento_em) WHERE excluido_em IS NULL;
CREATE INDEX IF NOT EXISTS ix_estoque_reserva_tenant_status ON integrarp.estoque_reserva (tenant_id, status);

DO $$
BEGIN
    IF to_regclass('integrarp.v125_audit_evento') IS NOT NULL AND to_regclass('integrarp.auditoria_evento') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.auditoria_evento (id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em) SELECT id, tenant_id, usuario_id, entidade, entidade_id, acao, detalhes, correlation_id, criado_em FROM integrarp.v125_audit_evento ON CONFLICT (id) DO NOTHING';
        ALTER TABLE integrarp.v125_audit_evento RENAME TO v125_audit_evento_legacy;
    END IF;
    IF to_regclass('integrarp.v125_outbox_evento') IS NOT NULL AND to_regclass('integrarp.outbox_evento') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.outbox_evento (id, tenant_id, tipo, tipo_evento, payload, payload_json, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em) SELECT id, tenant_id, tipo, tipo, payload, payload, status, tentativas, proxima_tentativa_em, correlation_id, criado_em, processado_em FROM integrarp.v125_outbox_evento ON CONFLICT (id) DO NOTHING';
        ALTER TABLE integrarp.v125_outbox_evento RENAME TO v125_outbox_evento_legacy;
    END IF;
    IF to_regclass('integrarp.v125_worker_lock') IS NOT NULL AND to_regclass('integrarp.worker_tenant_job_lock') IS NOT NULL THEN
        EXECUTE 'INSERT INTO integrarp.worker_tenant_job_lock (tenant_id, job_name, locked_until, correlation_id, atualizado_em) SELECT tenant_id, job_name, locked_until, correlation_id, updated_at FROM integrarp.v125_worker_lock ON CONFLICT (tenant_id, job_name) DO UPDATE SET locked_until = EXCLUDED.locked_until, correlation_id = EXCLUDED.correlation_id, atualizado_em = EXCLUDED.atualizado_em';
        ALTER TABLE integrarp.v125_worker_lock RENAME TO v125_worker_lock_legacy;
    END IF;
    IF to_regclass('integrarp.v125_dashboard_agregado') IS NOT NULL THEN
        ALTER TABLE integrarp.v125_dashboard_agregado RENAME TO v125_dashboard_agregado_legacy;
    END IF;
END $$;

CREATE OR REPLACE VIEW integrarp.vw_dashboard_operacional AS
SELECT
    t.id AS tenant_id,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('confirmado','em_separacao','separado','faturamento_pendente','aberto','em_andamento','andamento','processando')), 0)::integer AS pedidos_em_andamento,
    COALESCE((SELECT count(*) FROM integrarp.pedido p WHERE p.tenant_id = t.id AND lower(COALESCE(p.status, '')) IN ('rascunho','aguardando_confirmacao')), 0)::integer AS pedidos_aguardando_confirmacao,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional tf WHERE tf.tenant_id = t.id AND tf.vencimento_em < now() AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_vencidas,
    COALESCE((SELECT count(*) FROM integrarp.tarefa_operacional tf WHERE tf.tenant_id = t.id AND tf.vencimento_em::date = CURRENT_DATE AND lower(COALESCE(tf.status, '')) NOT IN ('concluida','concluído','cancelada')), 0)::integer AS tarefas_para_hoje,
    COALESCE((SELECT count(*) FROM integrarp.estoque_saldo es JOIN integrarp.produto p ON p.tenant_id = es.tenant_id AND p.id = es.produto_id WHERE es.tenant_id = t.id AND (COALESCE(es.quantidade, 0) - COALESCE(es.reservado, 0)) <= COALESCE(p.estoque_minimo, 0)), 0)::integer AS estoque_critico,
    COALESCE((SELECT count(*) FROM integrarp.estoque_reserva er WHERE er.tenant_id = t.id AND lower(COALESCE(er.status, '')) IN ('pendente','reservado')), 0)::integer AS reservas_pendentes,
    COALESCE((SELECT count(*) FROM integrarp.outbox_evento oe WHERE oe.tenant_id = t.id AND lower(COALESCE(oe.status, '')) IN ('erro','failed','falha')), 0)::integer AS outbox_com_erro,
    now() AS atualizado_em
FROM integrarp.tenant t;
-- IntegraRP v1.28 - Core Comercial em Produção
-- PostgreSQL 16 | schema integrarp | migration aditiva e idempotente

CREATE SCHEMA IF NOT EXISTS integrarp;

ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS setor_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS responsavel_usuario_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS formulario_resposta_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS checklist_resposta_json jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS vencimento_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS iniciado_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS concluido_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS cancelado_em timestamptz;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS motivo_cancelamento text;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS prioridade integer NOT NULL DEFAULT 3;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS sla_minutos integer;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS correlation_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS pedido_id uuid;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS legado_setor_text text;
ALTER TABLE integrarp.tarefa_operacional ADD COLUMN IF NOT EXISTS legado_checklist_json jsonb;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa_operacional' AND column_name = 'checklist_json') THEN
        EXECUTE 'UPDATE integrarp.tarefa_operacional SET checklist_resposta_json = COALESCE(checklist_resposta_json, checklist_json, ''[]''::jsonb), legado_checklist_json = COALESCE(legado_checklist_json, checklist_json)';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'integrarp' AND table_name = 'tarefa_operacional' AND column_name = 'setor') THEN
        EXECUTE 'UPDATE integrarp.tarefa_operacional SET legado_setor_text = COALESCE(legado_setor_text, setor)';
    END IF;
END $$;

DO $$
BEGIN
    IF to_regclass('integrarp.setor') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_setor
            FOREIGN KEY (tenant_id, setor_id) REFERENCES integrarp.setor(tenant_id, id) NOT VALID;
    END IF;
    IF to_regclass('integrarp.usuario') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_responsavel
            FOREIGN KEY (tenant_id, responsavel_usuario_id) REFERENCES integrarp.usuario(tenant_id, id) NOT VALID;
    END IF;
    IF to_regclass('integrarp.pedido') IS NOT NULL THEN
        ALTER TABLE integrarp.tarefa_operacional
            ADD CONSTRAINT fk_tarefa_operacional_pedido
            FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido(tenant_id, id) NOT VALID;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_responsavel ON integrarp.tarefa_operacional (tenant_id, responsavel_usuario_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_setor ON integrarp.tarefa_operacional (tenant_id, setor_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_status_vencimento ON integrarp.tarefa_operacional (tenant_id, status, vencimento_em);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_pedido ON integrarp.tarefa_operacional (tenant_id, pedido_id);
CREATE INDEX IF NOT EXISTS ix_tarefa_operacional_tenant_prioridade ON integrarp.tarefa_operacional (tenant_id, prioridade, vencimento_em);

ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS status_anterior text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS status_novo text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS motivo text;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS correlation_id uuid;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS usuario_id uuid;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS row_version bigint NOT NULL DEFAULT 1;
ALTER TABLE integrarp.pedido_historico_status ADD COLUMN IF NOT EXISTS excluido_em timestamptz;

DO $$
BEGIN
    ALTER TABLE integrarp.pedido_historico_status
        ADD CONSTRAINT fk_pedido_historico_status_pedido_tenant
        FOREIGN KEY (tenant_id, pedido_id) REFERENCES integrarp.pedido(tenant_id, id) NOT VALID;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_pedido_data ON integrarp.pedido_historico_status (tenant_id, pedido_id, criado_em DESC);
CREATE INDEX IF NOT EXISTS ix_pedido_historico_status_tenant_status ON integrarp.pedido_historico_status (tenant_id, status_novo);

ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS idempotency_key text;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS max_tentativas integer NOT NULL DEFAULT 5;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS proxima_tentativa_em timestamptz;
ALTER TABLE integrarp.outbox_evento ADD COLUMN IF NOT EXISTS correlation_id uuid;
CREATE INDEX IF NOT EXISTS ix_outbox_evento_tenant_status_proxima ON integrarp.outbox_evento (tenant_id, status, proxima_tentativa_em);
CREATE UNIQUE INDEX IF NOT EXISTS ux_outbox_evento_tenant_idempotency ON integrarp.outbox_evento (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
