using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DataAccess.Stock;

namespace PantryTests
{
    [TestClass]
    public class SingleBatchTestBase: PantryTestBase
    {
        protected int currentBatchId;

        [TestInitialize]
        public override void Initialize()
        {
            base.Initialize();

            currentBatchId =
                (new CreateBatch
                {
                    CreatedBy = systemUserId,
                    Note = string.Empty
                }).Execute(connection, transaction);
        }

        [TestCleanup]
        public override void Cleanup()
        {
            base.Cleanup();
        }
    }
}
