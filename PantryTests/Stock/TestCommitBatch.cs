using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataAccess.Stock;

namespace PantryTests.Stock
{
    [TestClass]
    public class TestCommitBatch: SingleBatchTestBase
    {
        [TestMethod]
        public void CommitBatch_Commits_Empty_Batch()
        {
            DateTime committed = 
                (new CommitBatch
                {
                    BatchId = currentBatchId,
                    CommittedToStockBy = systemUserId
                }).Execute(connection, transaction);

            Assert.IsTrue(committed > defaultDate);
        }
    }
}
