using Dapper;
using System.Collections.Generic;
using System.Data;

namespace Pantry.Common
{
    public class GetUnits
    {
        public class Result
        {
            public string Name { get; set; }
            public decimal StandardConversion { get; set; }
        }

        public IEnumerable<Result> Query(
            IDbConnection connection, 
            IDbTransaction transaction)
        {
            return
                connection.Query<Result>(
                    "Common.GetUnits",
                    commandType: CommandType.StoredProcedure,
                    param: this,
                    transaction: transaction);
        }
    }
}
