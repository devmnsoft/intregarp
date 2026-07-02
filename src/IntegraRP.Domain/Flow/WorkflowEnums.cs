namespace IntegraRP.Domain.Flow;

public enum ProcessElementType
{
    StartEvent,
    HumanTask,
    ServiceTask,
    Gateway,
    SubProcess,
    EndEvent
}

public enum ProcessInstanceStatus
{
    Draft,
    Running,
    Waiting,
    Completed,
    Cancelled,
    Failed
}

public enum WorkflowTaskStatus
{
    Open,
    InProgress,
    Completed,
    Cancelled,
    Overdue
}

public enum WorkflowTaskPriority
{
    Low,
    Normal,
    High,
    Critical
}

public enum WorkflowTriggerType
{
    Manual,
    NativeModuleEvent,
    DynamicModuleEvent,
    Webhook,
    Schedule,
    Message,
    FileImport
}
