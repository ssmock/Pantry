using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataAccess.Stock;

namespace PantryTests
{
    [TestClass]
    public class TestCancelBatch : SingleBatchTestBase
    {
        [TestMethod]
        public void CancelBatch_Cancels_Uncommitted_Batch()
        {
            (new CancelBatch
            {
                BatchId = currentBatchId,
                CancelledBy = systemUserId
            }).Execute(connection, transaction);
        }

        [TestMethod]
        public void CancelBatch_Fails_With_Committed_Batch()
        {
            try
            {
                (new CommitBatch
                {
                    BatchId = currentBatchId,
                    CommittedToStockBy = systemUserId
                }).Execute(connection, transaction);

                (new CancelBatch
                {
                    BatchId = currentBatchId,
                    CancelledBy = systemUserId
                }).Execute(connection, transaction);

                Assert.Fail();
            }
            catch (Exception ex)
            {
                Assert.IsInstanceOfType(ex,
                    typeof(System.Data.SqlClient.SqlException));
            }
        }
    }
}
