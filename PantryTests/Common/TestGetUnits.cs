using Microsoft.VisualStudio.TestTools.UnitTesting;
using Pantry.Common;
using System.Data.SqlClient;
using System.Linq;

namespace PantryTests.Common
{
    [TestClass]
    public class TestGetUnits: PantryTestBase
    {
        [TestMethod]
        public void GetUnits_Gets_All_Units()
        {
            var units =
                (new GetUnits()).Query(connection, transaction);

            Assert.IsTrue(units.Count() > 0);
        }
    }
}
