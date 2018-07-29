using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using IMS.EverestPortal.API;
using IMS.EverestPortal.API.Controllers;
using System.Linq;
using System.Web;
using System.IO;
using System.Web.SessionState;
using System.Reflection;
using System;
using System.Web.Routing;
using System.Collections.Specialized;
using System.Security.Principal;
using System.Security.Claims;
using System.Threading;
using System.Net;
using System.Text;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using IMS.EverestPortal.API.Models.Territory;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Threading.Tasks;

namespace IMS.EverestPortal.API.Controllers.Tests
{
    [TestClass()]
    public class TerritoryControllerTest
    {

        int unitTestClientId = -1;
        static Territory t = null;
        static Territory sampleTerritory = null;

        [TestInitialize]
        public void Setup()
        {
            TearDown();

            using (EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext())
            {
                var client = context.Clients.FirstOrDefault(c => c.Id == -1);
                if (client == null)
                {
                    context.Database.ExecuteSqlCommand(@"set identity_insert clients on
INSERT INTO [dbo].[Clients]([ID],[Name],[IsMyClient],[DivisionOf],[IRPClientId],[IRPClientNo])
     VALUES(-1, 'UnitTestClient', 0, null, null, null)
set identity_insert clients off
insert into irp.ClientMap values (-1, -1, -1)
"

);
                }
            }


            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {

                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                t = new Territory() { AD = "1", Client_Id = -1, DimensionID = 1, GuiId = new Guid().ToString(), IsBrickBased = false, IsReferenced = false, IsUsed = true, LastSaved = DateTime.Now, LD = "1", Name = "sample", SRA_Client = "1", SRA_Suffix = "1" };
                List<Level> levels = new List<Level>();
                Level national = new Level() { LevelNumber = 1, Name = "NATIONAL" };
                Level state = new Level() { LevelNumber = 2, Name = "STATE" };
                levels.Add(national); levels.Add(state);
                List<Group> groups = new List<Group>();
                Group aus = new Group() { GroupNumber = "1", CustomGroupNumber = "1", Name = "AUSTRALIA" };
                Group nsw = new Group() { GroupNumber = "11", CustomGroupNumber = "11", Name = "NSW" };
                List<Group> children = new List<Group>(); children.Add(nsw);
                aus.Children = children;
                groups.Add(aus);
                t.Levels = levels;
                t.RootGroup = aus;
                t.OutletBrickAllocation = new List<OutletBrickAllocation>();
                OutletBrickAllocation o = new OutletBrickAllocation() { BrickOutletCode = "20001", Type = "Brick" };
                t.OutletBrickAllocation.Add(o);
                request.Content = new ObjectContent<Territory>(t, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                //need to setup sample territory
                var task = Task.Run(async () => await territoriesController.postTerritory(unitTestClientId));
                task.Wait();
                var asyncFunctionResult = task.Result;

            }

            using (EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext())
            {
                sampleTerritory = context.Territories.FirstOrDefault(t => t.Client_Id == -1 && t.Name == "sample");                
            }
            t.Id = sampleTerritory.Id;
        }

        [TestCleanup]
        public void TearDown()
        {
            using (EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext())
            {
                context.Database.ExecuteSqlCommand(@"
delete from OutletBrickAllocations where TerritoryId in (select id from Territories where Client_id = -1)
delete from Levels where TerritoryId in (select id from Territories where Client_id = -1);

WITH CTE 
AS(
  SELECT child.id
  FROM dbo.groups child
  join Territories t on t.RootGroup_id = child.id and t.Client_id = -1
  WHERE child.ParentId = null

  UNION ALL

  SELECT parent.id
  FROM CTE nextOne
  INNER JOIN  dbo.groups parent ON parent.parentid = nextOne.id
)
delete g FROM groups g inner join cte c
on c.id = g.id;

delete from Territories where Client_id = -1

delete from irp.ClientMap where ClientId = -1
delete from Clients where Id = -1
");

            }
        }



        //public static HttpContext FakeHttpContext()
        //{
        //    var httpRequest = new HttpRequest("", "https://everest.imshealth.com/", "");
        //    var stringWriter = new StringWriter();
        //    var httpResponse = new HttpResponse(stringWriter);
        //    var httpContext = new HttpContext(httpRequest, httpResponse);

            //    var sessionContainer = new HttpSessionStateContainer("id", new SessionStateItemCollection(),
            //                                            new HttpStaticObjectsCollection(), 10, true,
            //                                            HttpCookieMode.AutoDetect,
            //                                            SessionStateMode.InProc, false);

            //    httpContext.Items["AspSession"] = typeof(HttpSessionState).GetConstructor(
            //                                BindingFlags.NonPublic | BindingFlags.Instance,
            //                                null, CallingConventions.Standard,
            //                                new[] { typeof(HttpSessionStateContainer) },
            //                                null)
            //                        .Invoke(new object[] { sessionContainer });

            //    return httpContext;
            //}

            //public class HttpContextManager
            //{
            //    private static HttpContextBase m_context;
            //    public static HttpContextBase Current
            //    {
            //        get
            //        {
            //            if (m_context != null)
            //                return m_context;

            //            if (HttpContext.Current == null)
            //                throw new InvalidOperationException("HttpContext not available");

            //            return new HttpContextWrapper(HttpContext.Current);
            //        }
            //    }

            //    public static void SetCurrentContext(HttpContextBase context)
            //    {
            //        m_context = context;
            //    }
            //}

            //private HttpContextBase GetMockedHttpContext()
            //{
            //    var context = new Mock<HttpContextBase>();
            //    var request = new Mock<HttpRequestBase>();
            //    var response = new Mock<HttpResponseBase>();
            //    var session = new Mock<HttpSessionStateBase>();
            //    var server = new Mock<HttpServerUtilityBase>();
            //    var user = new Mock<IPrincipal>();
            //    var identity = new Mock<IIdentity>();
            //    var urlHelper = new Mock<UrlHelper>();

            //    var routes = new RouteCollection();
            //    //MvcApplication.RegisterRoutes(routes);
            //    var requestContext = new Mock<RequestContext>();
            //    requestContext.Setup(x => x.HttpContext).Returns(context.Object);
            //    context.Setup(ctx => ctx.Request).Returns(request.Object);
            //    context.Setup(ctx => ctx.Response).Returns(response.Object);
            //    context.Setup(ctx => ctx.Session).Returns(session.Object);
            //    context.Setup(ctx => ctx.Server).Returns(server.Object);
            //    context.Setup(ctx => ctx.User).Returns(user.Object);
            //    user.Setup(ctx => ctx.Identity).Returns(identity.Object);
            //    identity.Setup(id => id.IsAuthenticated).Returns(true);
            //    identity.Setup(id => id.Name).Returns("admin@au.imshealth.com");            
            //    request.Setup(req => req.Url).Returns(new Uri("https://www.everest.imshealth.com"));
            //    request.Setup(req => req.RequestContext).Returns(requestContext.Object);
            //    requestContext.Setup(x => x.RouteData).Returns(new RouteData());
            //    request.SetupGet(req => req.Headers).Returns(new NameValueCollection());

            //    return context.Object;
            //}

        [TestMethod()]
        public void GetClientTerritoriesTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                var reponse = territoriesController.GetClientTerritories(unitTestClientId);
                Assert.IsNotNull(reponse);
                List<Territory> territories = JsonConvert.DeserializeObject<List<Territory>>(reponse);

                Assert.IsTrue(territories.Count > 0);

                Assert.IsTrue(territories[0].Client_Id == -1);

                Assert.IsTrue(territories[0].Name == "sample");
            }

        }
        [TestMethod()]
        public void GetClientTerritoriesV2Test()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                HttpRequestMessage request = new HttpRequestMessage();
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();

                var reponse = territoriesController.GetClientTerritoriesV2(unitTestClientId);
                Assert.IsNotNull(reponse);
                List<Territory> territories = JsonConvert.DeserializeObject<List<Territory>>(reponse.Content.ReadAsStringAsync().Result);

                Assert.IsNotNull(territories);
                Assert.IsNotNull(territories[0]);
                Assert.IsTrue(territories[0].Name.Contains("sample"));

            }

        }
        [TestMethod()]
        public void GetTerritoryByClientTest()
        {

            //HttpContextManager.SetCurrentContext(GetMockedHttpContext());

            //territoriesController.Request = new System.Net.Http.HttpRequestMessage();
            //territoriesController.Configuration = new System.Web.Http.HttpConfiguration();

            // Create the mock and set up the Link method, which is used to create the Location header.
            // The mock version returns a fixed string.
            //var mockUrlHelper = new Mock<UrlHelper>();
            //mockUrlHelper.Setup(x => x.Link(It.IsAny<string>(), It.IsAny<object>())).Returns(locationUrl);
            //territoriesController.Url = mockUrlHelper.Object;

            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                var reponse = territoriesController.GetTerritoryByClientData(unitTestClientId);

                Assert.IsNotNull(reponse);

                Assert.IsTrue(reponse.Count > 0);

                Assert.IsTrue(reponse[0].Client_Id == -1);


            }
        }

   

        [TestMethod()]
        public async void postTerritoryTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                t.Name = "sample2";
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(t, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = await territoriesController.postTerritory(unitTestClientId);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
                var territories = response.Content;
            }

        }
        [TestMethod()]
        public async void copyTerritoryTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                
                var response = await territoriesController.copyTerritory(unitTestClientId, t.Id, "copyOfTerritory", "IMS Standard Structure");

                Assert.IsNotNull(response);
            }
        }

        [TestMethod()]
        public async void editTerritoryTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();                
                request.Content = new ObjectContent<Territory>(t, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;
                
                var response = await territoriesController.editTerritory(unitTestClientId, sampleTerritory.Id);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
               
            }
        }
        [TestMethod()]
        public void deleteTerritoryTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.deleteTerritory(unitTestClientId, sampleTerritory.Id);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void ClientTerritoriesTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.ClientTerritories(unitTestClientId, sampleTerritory.Id, sampleTerritory.Name);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void updateTerritoryBaseInfoTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                t.Id = sampleTerritory.Id;
                t.LD = "2";
                request.Content = new ObjectContent<Territory>(t, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.updateTerritoryBaseInfo(unitTestClientId, sampleTerritory.Id);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);

                using (EverestPortal.API.DAL.EverestPortalContext context = new DAL.EverestPortalContext())
                {
                    var territory = context.Territories.FirstOrDefault(te => te.Id == sampleTerritory.Id);
                    Assert.IsNotNull(territory);
                    Assert.IsTrue(territory.LD == "2");
                }
               
            }
        }

        [TestMethod()]
        public void CheckIMSHierarchyTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.CheckIMSHierarchy(unitTestClientId, sampleTerritory.Id, sampleTerritory.Name);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void checkForTerritoryDefDuplicationTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.checkForTerritoryDefDuplication(unitTestClientId, sampleTerritory.Name);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void checkSRADuplicationTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.checkSRADuplication(unitTestClientId, sampleTerritory.Id, "2", "2", "2", "2");

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void GetBrickOutletTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.GetBrickOutlet("brick", "manager", unitTestClientId);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void GetBrickOutletAllocationCountTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.GetBrickOutletAllocationCount(unitTestClientId, sampleTerritory.Id, "brick");

                Assert.IsNotNull(response);
            }
        }

        [TestMethod()]
        public void GetBrickOutletUpdatedTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.GetBrickOutletUpdated("brick", sampleTerritory.Id, "manager", unitTestClientId);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void SubmitTerritoryTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;
                
                //add history entry test for submission
            }
        }

        [TestMethod()]
        public void checkSubcribedTerritoryDefTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.checkSubcribedTerritoryDef(unitTestClientId, sampleTerritory.Id);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }

        [TestMethod()]
        public void populateSRAInfoTest()
        {
            using (API.Controllers.TerritoriesController territoriesController = new API.Controllers.TerritoriesController())
            {
                territoriesController.Configuration = new System.Web.Http.HttpConfiguration();
                HttpRequestMessage request = new HttpRequestMessage();
                request.Content = new ObjectContent<Territory>(sampleTerritory, new JsonMediaTypeFormatter());
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                territoriesController.Request = request;

                var response = territoriesController.populateSRAInfo(unitTestClientId);

                Assert.IsNotNull(response);
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK);
            }
        }



    }
}

