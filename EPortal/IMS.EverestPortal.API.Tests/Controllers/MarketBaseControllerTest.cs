using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Grouping;
using IMS.EverestPortal.API.Models.Security;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass()]
    public class MarketBaseControllerTest
    {
        int demoClientId = 0;
        MarketDefinition marketDefinition = null;
        MarketBase marketBase = null;
        User user = null;
        EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext();

        [TestInitialize]
        public void Setup()
        {
            var client = context.Clients.FirstOrDefault(c => c.Name == "demonstration");
            if (client != null)
            {
                demoClientId = client.Id;
                marketDefinition = context.MarketDefinitions.FirstOrDefault(m => m.ClientId == client.Id);
                var marketDefBaseMap = context.MarketDefinitionBaseMaps.FirstOrDefault(m => m.MarketDefinitionId == marketDefinition.Id);
                marketBase = context.MarketBases.FirstOrDefault(m => m.Id == marketDefBaseMap.MarketBaseId);
            }
            user = context.Users.FirstOrDefault(u => u.UserName.ToLower() == "admin@au.imshealth.com");
        }

        [TestMethod()]
        public void TestGetAvailablePackList()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                //Arrange
                var controller = new API.Controllers.MarketBaseCreateController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetAvailablePackList();
                var result = JsonConvert.DeserializeObject<DataTable>(response.Content.ReadAsStringAsync().Result);

                watch.Stop();

                //Assert
                Assert.IsNotNull(response);
                //Assert.IsTrue(result.Length > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 15000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void TestGetMarketBasePacks()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                //Arrange
                var controller = new API.Controllers.MarketBaseCreateController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetMarketBasePacks(marketBase.Id, demoClientId);
                //var result = JsonConvert.DeserializeObject<DataTable>(response.Content.ReadAsStringAsync().Result);

                watch.Stop();

                //Assert
                Assert.IsNotNull(response);
                //Assert.IsTrue(result.Length > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                //Assert.IsTrue(elapsedMs < 15000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void TestGetClientName()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketBaseCreateController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetClientName(demoClientId);


                //Assert
                Assert.IsNotNull(response);
                Assert.IsTrue(response.ToUpper().Contains("DEMONSTRATION"));
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void TestGetEffectedMarketDefName()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketBaseCreateController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetEffectedMarketDefName(marketBase.Id, demoClientId);


                //Assert
                Assert.IsNotNull(response);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void TestcheckForMarketbaseDuplication()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketBaseCreateController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.checkForMarketbaseDuplication(marketBase.Id, demoClientId, marketBase.Name + ' ' + marketBase.Suffix);


                //Assert
                Assert.IsNotNull(response);
                Assert.IsFalse(response);

            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

    }

}
