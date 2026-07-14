CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS integrarp;

-- v1.15: schema_migrations é gerenciada exclusivamente pelo Migration Runner; registro legado removido.
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
