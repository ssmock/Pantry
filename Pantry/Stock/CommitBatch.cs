using Dapper;
using System;
using System.Collections.Generic;
using System.Data;

namespace DataAccess.Stock
{
    /// <summary>
    /// Updates the stock (Stock.Item) with the specified batch, returning the 
    /// date/time of the commit.
    /// </summary>
    /// <remarks>
    /// NOTE: Metric measures are not fully supported yet, so the stock is 
    /// entirely maintained in oz and ea.
    /// 
    /// Fails hard if any stock quantities fall below zero.
    /// </remarks>
    public class CommitBatch
    {
        private const string ProcedureName = "Stock.CommitBatch";

        public int? BatchId { get; set; }
        public int? CommittedToStockBy { get; set; }
        public DateTime? CommittedToStock { get; set; }

        private DynamicParameters GetParameters()
        {
            DynamicParameters parameters = new DynamicParameters(this);

            parameters.Add(
                "@CommittedToStock",
                value: CommittedToStock ?? DateTime.Now,
                direction: ParameterDirection.InputOutput);

            return parameters;
        }

        public DateTime Execute(
            IDbConnection connection, IDbTransaction transaction = null)
        {
            DynamicParameters parameters = GetParameters();

            connection.Execute(
                ProcedureName,
                commandType: CommandType.StoredProcedure,
                param: parameters,
                transaction: transaction);

            return parameters.Get<DateTime>("@CommittedToStock");
        }
    }
}
