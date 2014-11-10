using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace PantryTests
{
    [TestClass]
    public class PantryTestBase
    {
        protected IDbConnection connection;
        protected IDbTransaction transaction;

        protected const int systemUserId = 1;
        protected static DateTime defaultDate = new DateTime(1900, 1, 1);

        [TestInitialize]
        public virtual void Initialize()
        {
            connection = new SqlConnection(
                ConfigurationManager.ConnectionStrings["PantryTest"]
                    .ConnectionString);

            connection.Open();

            transaction = connection.BeginTransaction();
        }

        [TestCleanup]
        public virtual void Cleanup()
        {
            transaction.Rollback();
            connection.Close();
        }
    }
}
