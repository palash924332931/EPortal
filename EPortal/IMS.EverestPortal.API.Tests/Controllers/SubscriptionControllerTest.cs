using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Linq;
using Newtonsoft.Json;
using IMS.EverestPortal.API.Models.Subscription;
using System.Collections.Generic;
using System.Web.Http.Results;
using System.Threading.Tasks;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Routing;
using Newtonsoft.Json.Linq;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Controllers;
using System.Net;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass()]
    public class SubscriptionControllerTest
    {

        API.Controllers.SubscriptionController subscriptionController = new API.Controllers.SubscriptionController();
        EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext();
        int demoClientId = 0;
        int demoClientID = -1;
        [TestInitialize]
        public void Setup()
        {
            // EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext();
            var client = context.Clients.FirstOrDefault(c => c.Name == "demonstration");
            if (client != null) { demoClientId = client.Id; }


        }

        [TestMethod]
        public void GetValidDataTypeforSubscriptionTest()
        {

            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);

            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.DataTypeId);
            int DatatypeId= result[0].subscription.ServiceId;
            var DataTypes = context.DataTypes.Select(x => x.DataTypeId == DatatypeId).ToList();
            Assert.IsTrue(DataTypes.Count() > 0);

        }

        [TestMethod]
        public void GetValidServiceforSubscriptionTest()
        {

            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);

            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.ServiceId);
            int serviceId = result[0].subscription.ServiceId;
            var services = context.Services.Select(x => x.ServiceId == serviceId).ToList();
            Assert.IsTrue(services.Count() > 0);

        }

        [TestMethod]
        public void GetValidSourceforSubscriptionTest()
        {

            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);

            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.SourceId);
            int srcid = result[0].subscription.SourceId;
            var sources = context.Sources.Select(x => x.SourceId  == srcid).ToList();
            Assert.IsTrue(sources.Count() > 0);
        }
        [TestMethod]
        public void GetValidStartDateforSubscriptionTest()
        {
            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.StartDate);
        }

        [TestMethod]
        public void GetValidEndDateforSubscriptionTest()
        {

            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.EndDate);

        }
        [TestMethod]
        public void GetValidServiceTerritoryforSubscriptionTest()
        {

            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.ServiceTerritoryId);
            int iserviceTerritoryId = result[0].subscription.ServiceTerritoryId;
            var Territories = context.serviceTerritory.Select(x => x.ServiceTerritoryId == iserviceTerritoryId).ToList();
            Assert.IsTrue(Territories.Count() > 0);

        }

        [TestMethod]
        public void GetSubscriptionByClientTest()
        {

            var country = context.Countries.FirstOrDefault(c => c.Name == "AUS");
            int countryId = country.CountryId;
            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);

            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].subscription.CountryId);
            Assert.IsTrue(result[0].subscription.CountryId == countryId);

        }


        [TestMethod]
        public void GetMarketBasesByClientTest()
        {
            var response = subscriptionController.ClientMarketBaseDetails(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientMarketBase[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsNotNull(result[0].MarketBaseId);
            Assert.IsTrue(result[0].ClientId == demoClientId);
        }

        [TestMethod]
        public void GetMarketBasesforSubscriptionTest()
        {
            var subscriptions = context.subscription.FirstOrDefault(s => s.ClientId == demoClientId);
            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<ClientSubscriptionDTO[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsNotNull(result[0].subscription.SubscriptionId);
            Assert.IsTrue(result[0].ClientId == demoClientId);
            Assert.IsTrue(result[0].MarketBase.Count > 0);
        }

        [TestMethod]
        public void GetSubscriptionDurationTest()
        {
            var response = subscriptionController.GetSubscriptions(demoClientId);
            var result = JsonConvert.DeserializeObject<SubscriptionDTO[]>(response);
            Assert.IsNotNull(response);
            Assert.IsTrue(result.Length > 0);
            Assert.IsNotNull(result[0].StartDate);
            Assert.IsNotNull(result[0].EndDate);
            Assert.IsTrue(result[0].EndDate >= result[0].StartDate);
        }

        class subscriptionMktDTOTest
        {
            public int subscriptionid { get; set; }
            public int clientid { get; set; }
            public List<int> mktbaseid { get; set; }
        }
        [TestMethod]
        public void AddMarketBaseToSubscriptionTest()
        {
            Subscription subscriptionsample = context.subscription.Where(x => x.ClientId == demoClientId).FirstOrDefault();
            ClientMarketBases mktbase = context.ClientMarketBases.Where(x => x.ClientId == demoClientId).FirstOrDefault();

            subscriptionMktDTOTest subscriptionMkt = new subscriptionMktDTOTest();
            subscriptionMkt.subscriptionid = subscriptionsample.SubscriptionId;
            subscriptionMkt.mktbaseid = new List<int>();
            subscriptionMkt.mktbaseid.Add(mktbase.MarketBaseId);
            subscriptionMkt.clientid = demoClientId;
            JObject request = (JObject)JToken.FromObject(subscriptionMkt);
            var subscriptionController = new SubscriptionController
            {
                Request = new System.Net.Http.HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };

            var response = subscriptionController.addMarketBase(request);
            int mktbaseID = subscriptionMkt.mktbaseid[0];
            var subscriptionMkts = context.subscriptionMarket.Where(x => x.SubscriptionId == subscriptionMkt.subscriptionid && x.MarketBaseId == mktbaseID).ToList();

            Assert.IsNotNull(response);
            Assert.IsTrue(response.IsSuccessStatusCode);
            Assert.IsTrue(subscriptionMkts.Count() > 0);

        }

        class subscriptionMarketDTOTest
        {
            public int subscriptionid { get; set; }
            public int clientid { get; set; }
            public int mktbaseid { get; set; }
        }
        [TestMethod]
        public void DeleteMarketBaseFromSubscriptionTest()
        {
            Subscription subscriptionsample = context.subscription.Where(x => x.ClientId == demoClientId).FirstOrDefault();
            ClientMarketBases mktbase = context.ClientMarketBases.Where(x => x.ClientId == demoClientId).FirstOrDefault();

            subscriptionMarketDTOTest subscriptionMkt = new subscriptionMarketDTOTest();
            subscriptionMkt.subscriptionid = subscriptionsample.SubscriptionId;
            subscriptionMkt.mktbaseid= mktbase.MarketBaseId;
            JObject request = (JObject)JToken.FromObject(subscriptionMkt);
            var subscriptionController = new SubscriptionController
            {
                Request = new System.Net.Http.HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
            var response = subscriptionController.deleteMarketBase(request);
            var subscriptionMkts = context.subscriptionMarket.Where(x => x.SubscriptionMarketId == subscriptionMkt.subscriptionid && x.MarketBaseId == subscriptionMkt.mktbaseid);

            Assert.IsNotNull(response);
            Assert.IsTrue(response.IsSuccessStatusCode);
            Assert.IsTrue(subscriptionMkts.Count() == 0);
        }

         class subscriptionDTOTest
        {
            public int subscriptionid { get; set; }
            public int clientid { get; set; }
            public DateTime fromdate { get; set; }
            public DateTime todate { get; set; }
        }
        [TestMethod]
        public void UpdateSubscripitionTest()
        {
          
            Subscription subscriptionsample = context.subscription.Where(x => x.ClientId == demoClientId).FirstOrDefault();
            subscriptionDTOTest subscription = new subscriptionDTOTest();
            subscription.subscriptionid = subscriptionsample.SubscriptionId;
            subscription.clientid = demoClientId;
            subscription.fromdate = DateTime.Now;
            subscription.todate = DateTime.Now.AddMonths(3);
           // subscriptionMkt.MarketBaseId = mktbase.MarketBaseId;
            JObject request = (JObject)JToken.FromObject(subscription);
            var subscriptionController = new SubscriptionController
            {
                Request = new System.Net.Http.HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };

            var response = subscriptionController.updateSubscription(request);
            Subscription subscriptionupdated = context.subscription.Where(x => x.SubscriptionId == subscription.subscriptionid).FirstOrDefault();

            Assert.IsNotNull(response);
            Assert.IsTrue(response.IsSuccessStatusCode);
            Assert.IsNotNull(subscriptionupdated);
            Assert.AreEqual(response.StatusCode, HttpStatusCode.Created);
        }


    }

}
