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
    public class MarketViewControllerTest
    {
        int demoClientId = 0;
        MarketDefinition marketDefinition = null;
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
            }
            user = context.Users.FirstOrDefault(u => u.UserName.ToLower() == "admin@au.imshealth.com");
        }

        [TestMethod()]
        public void GetClient()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetClient(demoClientId);
                var result = JsonConvert.DeserializeObject<MarketDefinition[]>(response.Content.ReadAsStringAsync().Result);

                var actMarketDefinition = context.MarketDefinitions.Where(m => m.ClientId == demoClientId).ToList();

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.Length > 0);
                Assert.IsTrue(result.Length == actMarketDefinition.Count);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetMarketDefByClient()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.GetMarketDefByClient(demoClientId);
                var result = JsonConvert.DeserializeObject<MarketDefDTO[]>(response.Content.ReadAsStringAsync().Result);

                var marketDef = (from mar in context.MarketDefinitions
                                 where mar.ClientId == demoClientId
                                 select mar).ToList();

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.Length > 0);
                Assert.IsTrue(result.Length == marketDef.Count);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void ClientMarketBase()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.ClientMarketBase(demoClientId);


                //Assert
                Assert.IsNotNull(response);
                Assert.IsTrue(response != "[]");
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetMarketBases()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
                var response = controller.GetMarketBases(demoClientId, marketDefinitionId, "All Market Base");
                var result = JsonConvert.DeserializeObject<DataTable>(response.Content.ReadAsStringAsync().Result);

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.Rows[0]["ClientName"].ToString().ToLower() == "demonstration");
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetStaticAvailablePackList()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                var query = "SELECT DISTINCT TOP 1 * from DIMProduct_Expanded";
                controller.Request.Content = new StringContent(query);
                //controller.Request.Content = new ObjectContent<string>(query, new JsonMediaTypeFormatter(), "application/json");

                //Act
                var response = controller.GetStaticAvailablePackList(demoClientId);
                var result = JsonConvert.DeserializeObject<DataTable>(response.Content.ReadAsStringAsync().Result);

                watch.Stop();

                //Assert
                Assert.IsNotNull(response);
                //Assert.IsTrue(result.Length > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetDynamicAvailablePackList()
        {
            try
            {
                var watch = System.Diagnostics.Stopwatch.StartNew();

                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                var query = "SELECT DISTINCT TOP 1 * from DIMProduct_Expanded";
                controller.Request.Content = new StringContent(query);
                //controller.Request.Content = new ObjectContent<string>(query, new JsonMediaTypeFormatter(), "application/json");

                //Act
                var response = controller.GetDynamicAvailablePackList(demoClientId);
                var result = JsonConvert.DeserializeObject<DataTable>(response.Content.ReadAsStringAsync().Result);

                watch.Stop();

                //Assert
                Assert.IsNotNull(response);
                //Assert.IsTrue(result.Length > 0);
                var elapsedMs = watch.ElapsedMilliseconds;
                Assert.IsTrue(elapsedMs < 5000);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void CheckForMarketDefDuplication()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var marketDefName = marketDefinition.Name + "$$";
                var response = controller.checkForMarketDefDuplication(demoClientId, marketDefName);

                var data = context.MarketDefinitions.Where(u => u.Name.Equals(marketDefName, StringComparison.CurrentCultureIgnoreCase) && u.ClientId == demoClientId).FirstOrDefault();
                bool validate = false;
                if (data == null)
                {
                    validate = true;
                }
                

                //Assert
                Assert.IsNotNull(response);
                Assert.IsTrue(response);
                Assert.IsTrue(validate == response);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void CheckForMarketDefDuplication_ValidateForOtherMarketDef()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                var response = controller.checkForMarketDefDuplication(demoClientId, marketDefinition.Id, marketDefinition.Name);

                var data = context.MarketDefinitions.Where(u => u.Name.Equals(marketDefinition.Name, StringComparison.CurrentCultureIgnoreCase) && u.ClientId == demoClientId && u.Id != marketDefinition.Id).FirstOrDefault();
                bool validate = false;
                if (data == null)
                    validate = true;

                //Assert
                Assert.IsNotNull(response);
                Assert.IsTrue(response);
                Assert.IsTrue(response == validate);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetClientMarketDef()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
                var response = controller.getClientMarketDef(demoClientId, marketDefinitionId);
                var result = JsonConvert.DeserializeObject<MarketDefinition>(response.Content.ReadAsStringAsync().Result);

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.ClientId == demoClientId);
                Assert.IsTrue(result.Id == marketDefinitionId);
                Assert.IsTrue(result.Name == marketDefinition.Name);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        [TestMethod()]
        public void GetMarketDefinitionPacks()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
                var response = controller.getMarketDefinitionPacks(demoClientId, marketDefinitionId);
                var result = JsonConvert.DeserializeObject<Packs[]>(response.Content.ReadAsStringAsync().Result);

                List<Packs> marketDefinitionPacks = context.Database.SqlQuery<Packs>("Select * from vwMarketDefinitionPacks Where MarketDefinitionID=" + marketDefinitionId).ToList();

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.Length > 0);
                Assert.IsTrue(result.Length == marketDefinitionPacks.Count);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        //Not used
        //[TestMethod()]
        //public void SaveClientMarketDef()
        //{
        //    Assert.Fail();
        //}

        //Not used
        //[TestMethod()]
        //public void EditClientMarketDef()
        //{
        //    Assert.Fail();
        //}

        //Not used
        //[TestMethod()]
        //public void DeleteClientMarketDef()
        //{
        //    Assert.Fail();
        //}

        [TestMethod()]
        public void CheckSubcribedMarketDef()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
                var response = controller.checkSubcribedMarketDef(demoClientId, marketDefinitionId);
                var result = JsonConvert.DeserializeObject<string[]>(response);

                var subcribedMarketList = context.DeliveryMarkets.Where(p => p.MarketDefId == marketDefinitionId).ToList();
                string subscriptionName = "";
                if (subcribedMarketList.Count > 0)
                    subscriptionName = getSubscriptionName(subcribedMarketList[0].deliverables);


                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.Length > 0);
                Assert.IsTrue(result.Contains(subscriptionName));
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        //Related to Lock History
        //[TestMethod()]
        //public void LockHistories()
        //{
        //    try
        //    {
        //        var watch = System.Diagnostics.Stopwatch.StartNew();

        //        //Arrange
        //        var controller = new API.Controllers.MarketViewController
        //        {
        //            Request = new System.Net.Http.HttpRequestMessage(),
        //            Configuration = new HttpConfiguration()
        //        };

        //        //Act
        //        int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
        //        int userId = user != null ? user.UserID : 0;
        //        var response = controller.LockHistories(userId, marketDefinitionId, "Market Module", "Edit Lock", "Active");
        //        var result = JsonConvert.DeserializeObject<LockHistory[]>(response);

        //        watch.Stop();

        //        //Assert
        //        Assert.IsNotNull(result);
        //        //Assert.IsTrue(result.Length > 0);
        //        var elapsedMs = watch.ElapsedMilliseconds;
        //        //Assert.IsTrue(elapsedMs < 5000);
        //    }
        //    catch (Exception exc)
        //    {
        //        Assert.Fail(exc.Message);
        //    }
        //}

        //[TestMethod()]
        //public void GetDefinitionLockHistories()
        //{
        //    try
        //    {
        //        var watch = System.Diagnostics.Stopwatch.StartNew();

        //        //Arrange
        //        var controller = new API.Controllers.MarketViewController
        //        {
        //            Request = new System.Net.Http.HttpRequestMessage(),
        //            Configuration = new HttpConfiguration()
        //        };

        //        //Act
        //        int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
        //        int userId = user != null ? user.UserID : 0;
        //        var response = controller.getDefinitionLockHistories(userId, marketDefinitionId, "Market Module", "Edit Lock", "Active");
        //        var result = JsonConvert.DeserializeObject<LockHistory[]>(response);

        //        watch.Stop();

        //        //Assert
        //        Assert.IsNotNull(result);
        //        //Assert.IsTrue(result.Length > 0);
        //        var elapsedMs = watch.ElapsedMilliseconds;
        //        //Assert.IsTrue(elapsedMs < 5000);
        //    }
        //    catch (Exception exc)
        //    {
        //        Assert.Fail(exc.Message);
        //    }
        //}

        [TestMethod()]
        public void UpdateMarketDefName()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketViewController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;
                string marketDefinitionName = marketDefinition != null ? marketDefinition.Name : "test";
                var response = controller.updateMarketDefName(demoClientId, marketDefinitionId, marketDefinitionName);

                var data = context.Database.ExecuteSqlCommand("Update MarketDefinitions set Name='" + marketDefinitionName + "' Where Id=" + marketDefinitionId + "");

                bool validate = false;
                if (data == 1)
                    validate = true;
                

                //Assert
                Assert.IsNotNull(response);
                Assert.IsTrue(response);
                Assert.IsTrue(response == validate);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }
        }

        //Related to Audit Versioning
        //[TestMethod()]
        //public void SubmitMarketDef()
        //{
        //    Assert.Fail();
        //}

        private string getSubscriptionName(Deliverables obj)
        {
            string deliveryName = string.Empty;
            deliveryName = obj.subscription.country.Name + " " + obj.subscription.service.Name + " " + obj.subscription.dataType.Name
                + " " + obj.subscription.source.Name + " ";

            deliveryName = deliveryName + obj.deliveryType.Name + " " + obj.frequencyType.Name;
            return deliveryName;
        }
    }

}
