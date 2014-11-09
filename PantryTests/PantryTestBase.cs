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

        [TestInitialize]
        public void Initialize()
        {
            connection = new SqlConnection(
                ConfigurationManager.ConnectionStrings["PantryTest"]
                    .ConnectionString);

            connection.Open();

            transaction = connection.BeginTransaction();
        }

        [TestCleanup]
        public void Cleanup()
        {
            transaction.Rollback();
            connection.Close();
        }
    }
}
