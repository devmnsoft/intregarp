using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;

public sealed record AuthResult<T>(bool Success, int StatusCode, string Code, string Message, T? Value = default)
{
    public static AuthResult<T> Ok(T value) => new(true, 200, "ok", "OK", value);
    public static AuthResult<T> Accepted(string code, string message) => new(true, 202, code, message);
    public static AuthResult<T> Fail(int statusCode, string code, string message) => new(false, statusCode, code, message);
}
