using Dapper;
using System;
using System.Collections.Generic;
using System.Data;

namespace DataAccess.Stock
{
    /// <summary>
    /// Removes the batch with the specified ID, provided that the batch has 
    /// not already been committed.
    /// </summary>
    /// <remarks>
    /// Fails hard if the batch was already committed.
    /// </remarks>
    public class CancelBatch
    {
        private const string ProcedureName = "Stock.CancelBatch";

        public int? BatchId { get; set; }
        public int? CancelledBy { get; set; }

        public void Execute(
            IDbConnection connection, IDbTransaction transaction = null)
        {
            connection.Execute(
                ProcedureName,
                commandType: CommandType.StoredProcedure,
                param: this,
                transaction: transaction);
        }
    }
}
