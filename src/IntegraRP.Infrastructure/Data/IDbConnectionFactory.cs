using System.Data;namespace IntegraRP.Infrastructure.Data;public interface IDbConnectionFactory{Task<IDbConnection> OpenConnectionAsync(CancellationToken cancellationToken);}
