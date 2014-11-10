using Dapper;
using System.Collections.Generic;
using System.Data;

namespace DataAccess.Stock
{
    /// <summary>
    /// Creates a new change batch, returning its ID.
    /// </summary>
    /// <remarks>
    /// Raises an FK error if CreatedBy is invalid.
    /// </remarks>
    public class CreateBatch
    {
        private const string ProcedureName = "Stock.CreateChangeBatch";

        public int? CreatedBy { get; set; }
        public string Note { get; set; }

        private DynamicParameters GetParameters()
        {
            DynamicParameters parameters = new DynamicParameters(this);

            parameters.Add(
                "@Id",
                value: 0,
                direction: ParameterDirection.InputOutput);

            return parameters;
        }

        public int Execute(IDbConnection connection, IDbTransaction transaction = null)
        {
            DynamicParameters parameters = GetParameters();

            connection.Execute(
                ProcedureName,
                commandType: CommandType.StoredProcedure,
                param: parameters,
                transaction: transaction);

            return parameters.Get<int>("@Id");
        }
    }
}
