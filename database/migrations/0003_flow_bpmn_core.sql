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
