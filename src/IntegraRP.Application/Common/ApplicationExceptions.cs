namespace IntegraRP.Application.Common;

public class ValidationException(string message) : Exception(message);
public class BusinessRuleException(string message) : Exception(message);
public class NotFoundException(string message) : Exception(message);
public class ConflictException(string message) : Exception(message);
public class ConcurrencyException(string message) : Exception(message);
public class ForbiddenException(string message) : Exception(message);
public class UnauthorizedContextException(string message) : Exception(message);
public class DependencyUnavailableException(string message, Exception? inner = null) : Exception(message, inner);
