using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataAccess.Stock;

namespace PantryTests.Stock
{
    [TestClass]
    public class TestCreateBatch: PantryTestBase
    {
        [TestMethod]
        public void CreateBatch_Fails_With_Invalid_User()
        {
            try
            {
                (new CreateBatch
                {
                    CreatedBy = -1,
                    Note = string.Empty
                }).Execute(connection, transaction);

                Assert.Fail();
            }
            catch (Exception ex)
            {
                Assert.IsInstanceOfType(ex,
                    typeof(System.Data.SqlClient.SqlException));
            }
        }

        [TestMethod]
        public void CreateBatch_Creates_Simple_Batch()
        {
            int batchId =
                (new CreateBatch
                {
                    CreatedBy = systemUserId,
                    Note = string.Empty
                }).Execute(connection, transaction);

            Assert.IsTrue(batchId > 0);
        }
    }
}
