namespace IntegraRP.Domain.Studio;

public enum DynamicFieldType
{
    Text,
    TextArea,
    Number,
    Money,
    Date,
    DateTime,
    Boolean,
    Select,
    MultiSelect,
    User,
    Sector,
    Client,
    Product,
    Order,
    File,
    Photo,
    Signature,
    Gps,
    Json,
    Relation
}

public enum DynamicActionType
{
    Open,
    Create,
    Edit,
    Approve,
    Reject,
    SendToAnalysis,
    Complete,
    Cancel,
    CreateTask,
    StartWorkflow,
    SendNotification,
    CallWebhook,
    UpdateKpi
}

public enum DynamicModuleTargetKind
{
    Native,
    Dynamic
}
