namespace IntegraRP.Domain.Studio;

public enum DynamicModuleStatus { Draft, Published, Archived }
public enum DynamicFieldType { Text, TextArea, Number, Money, Date, DateTime, Boolean, Select, MultiSelect, User, Sector, Client, Product, Order, FinancialTitle, Task, ProcessInstance, File, Photo, Signature, Gps, Json, Relation }
public enum DynamicActionType { Open, Create, Edit, Approve, Reject, SendToAnalysis, Complete, Cancel, CreateTask, StartWorkflow, SendNotification, CallWebhook, UpdateKpi, CustomRule }
public enum DynamicRelationshipType { OneToOne, OneToMany, ManyToOne, ManyToMany }
public enum DynamicTargetKind { Native, Dynamic }
public enum DynamicModuleTargetKind { Native, Dynamic }
public enum DynamicRecordStatus { Active, Deleted, Archived }
public enum DynamicPublishStatus { Valid, Warning, Invalid }
public enum DynamicScreenType { List, Form, Detail }
public enum DynamicValidationSeverity { Info, Warning, Error }
public enum DynamicEventType { RecordCreated, RecordUpdated, RecordDeleted, ActionExecuted, WorkflowStarted, WorkflowFailed }
