-- Fase 04: reconciliação canônica de tabelas repetidas no legado.
ALTER TABLE integrarp.processo_definicao ADD COLUMN IF NOT EXISTS descricao text;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS numero_versao integer;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS publicado_em timestamptz;
ALTER TABLE integrarp.processo_versao ADD COLUMN IF NOT EXISTS bpmn_json jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS tipo text;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS descricao text;
ALTER TABLE integrarp.processo_elemento ADD COLUMN IF NOT EXISTS ordem numeric(12,4) NOT NULL DEFAULT 0;
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS elemento_origem_id uuid;
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS elemento_destino_id uuid;
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS condicao_tipo text NOT NULL DEFAULT 'always';
ALTER TABLE integrarp.processo_transicao ADD COLUMN IF NOT EXISTS ordem numeric(12,4) NOT NULL DEFAULT 0;
UPDATE integrarp.processo_definicao SET processo_definicao_id=id WHERE processo_definicao_id IS NULL;
UPDATE integrarp.processo_versao SET processo_versao_id=id WHERE processo_versao_id IS NULL;
UPDATE integrarp.processo_elemento SET processo_elemento_id=id WHERE processo_elemento_id IS NULL;
UPDATE integrarp.processo_transicao SET processo_transicao_id=id WHERE processo_transicao_id IS NULL;
UPDATE integrarp.processo_instancia SET processo_instancia_id=id WHERE processo_instancia_id IS NULL;
