namespace IntegraRP.Domain.Flow;

public enum ProcessDefinitionStatus { Rascunho, Publicado, Arquivado }
public enum ProcessVersionStatus { Rascunho, Publicada, Arquivada }
public enum ProcessElementType { StartEvent, HumanTask, ServiceTask, Gateway, SubProcess, EndEvent }
public enum ProcessInstanceStatus { EmAndamento, AguardandoTarefa, Concluido, Cancelado, Erro }
public enum WorkflowTaskStatus { Aberta, Atribuida, EmAndamento, Concluida, Cancelada, Atrasada }
public enum WorkflowTaskPriority { Baixa, Media, Alta, Critica }
public enum WorkflowTriggerType { Manual, NativeModuleEvent, DynamicModuleEvent, Webhook, Schedule, Message, FileImport }
public enum TransitionConditionType { Always, VariableEquals, VariableNotEquals, VariableGreaterThan, VariableLessThan, ExpressionJson }
public enum BusinessEventStatus { Pendente, Processado, Erro }
public enum OutboxEventStatus { Pendente, Processado, Erro }
