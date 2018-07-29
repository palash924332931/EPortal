using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Grouping;
using IMS.EverestPortal.API.Models.Security;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.EverestPortal.API.Tests.Controllers
{
    [TestClass()]
    public class MarketGroupControllerTest
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
        public void GetMarketGroup()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketGroupController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;

                var marketGroupView = context.Database.SqlQuery<GroupView>("select * from [dbo].[vwGroupView] where marketdefinitionid=" + marketDefinitionId).ToList();
                var marketGroupPack = context.MarketGroupPacks.Where(p => p.MarketDefinitionId == marketDefinitionId).ToList();
                var marketGroupFilter = context.MarketGroupFilters.Where(f => f.MarketDefinitionId == marketDefinitionId).ToList();
                
                var response = controller.GetMarketGroup(marketDefinitionId);
                var result = JsonConvert.DeserializeObject<MarketGroupTestDTO>(response.Content.ReadAsStringAsync().Result);

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.MarketGroupView.Count == marketGroupView.Count);
                Assert.IsTrue(result.MarketGroupPacks.Count == marketGroupPack.Count);
                Assert.IsTrue(result.MarketGroupFilter.Count == marketGroupFilter.Count);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }

        [TestMethod()]
        public async Task SaveMarketGroupDetails()
        {
            try
            {
                //Arrange
                var controller = new API.Controllers.MarketGroupController
                {
                    Request = new System.Net.Http.HttpRequestMessage(),
                    Configuration = new HttpConfiguration()
                };

                //Act
                int marketDefinitionId = marketDefinition != null ? marketDefinition.Id : 0;

                var marketGroupView = context.Database.SqlQuery<GroupView>("select * from [dbo].[vwGroupView] where marketdefinitionid=" + marketDefinitionId).ToList();
                var marketGroupPack = context.MarketGroupPacks.Where(p => p.MarketDefinitionId == marketDefinitionId).ToList();
                var marketGroupFilter = context.MarketGroupFilters.Where(f => f.MarketDefinitionId == marketDefinitionId).ToList();

                var marketDefinitionDetails = new MarketDefinitionDetails();
                marketDefinitionDetails.MarketDefinition = marketDefinition;
                marketDefinitionDetails.GroupView = marketGroupView;
                marketDefinitionDetails.MarketGroupPack = marketGroupPack;
                marketDefinitionDetails.MarketGroupFilter = marketGroupFilter;


                controller.Request.Content = new ObjectContent<MarketDefinitionDetails>(marketDefinitionDetails, new JsonMediaTypeFormatter(), "application/json");
                var response = await controller.SaveMarketGroupDetails(marketDefinitionId, demoClientId);
                var result = JsonConvert.DeserializeObject<MarketDefinition>(response.Content.ReadAsStringAsync().Result);

                //Assert
                Assert.IsNotNull(result);
                Assert.IsTrue(result.ClientId == demoClientId);
                Assert.IsTrue(result.Name == marketDefinition.Name);
            }
            catch (Exception exc)
            {
                Assert.Fail(exc.Message);
            }

        }
    }

    public class MarketGroupTestDTO
    {
        public List<GroupView> MarketGroupView { get; set; }
        public List<MarketGroupPacks> MarketGroupPacks { get; set; }
        public List<MarketGroupFilter> MarketGroupFilter { get; set; }
    }
}
