using IMS.EverestPortal.API.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Configuration;
using Newtonsoft.Json;
using IMS.EverestPortal.API.Models.Subscription;
using IMS.EverestPortal.API.Models;
using Newtonsoft.Json.Linq;
using IMS.EverestPortal.API.Models.Deliverable;
using System.IO;
using OfficeOpenXml;
using System.Net.Http.Headers;
using System.Reflection;
using System.ComponentModel;
using System.Collections;
using System.Xml.Serialization;
using System.Text;
using IMS.EverestPortal.API.Audit;

namespace IMS.EverestPortal.API.Controllers
{

    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class SubscriptionController : ApiController
    {
        private EverestPortalContext dbContext = new EverestPortalContext();
        // Picks the value of Connection string  from config File
        string ConnectionString = "EverestPortalConnection";

        [Route("api/ClientMarketBaseDetails")]
        [HttpGet]
        public string ClientMarketBaseDetails(int id)
        {
            DataTable clientMarketBase = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("GetClientMarketBaseDetails", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@ClientId", SqlDbType.Int));
                    cmd.Parameters["@ClientId"].Value = id; //hardcoded for now

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        da.Fill(clientMarketBase);
                    }

                }
            }
            //var objClient = dbContext.Clients.Where(u => u.Id == id).FirstOrDefault();
            var json = JsonConvert.SerializeObject(clientMarketBase, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        [Route("api/GetSubscriptions")]
        [HttpGet]
        public string GetSubscriptions(int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return "";

            List<SubscriptionMarket> lstsubmkt = new List<SubscriptionMarket>();
            lstsubmkt = dbContext.subscriptionMarket.Where(q => q.subscription.ClientId == clientid).ToList();
            List<ClientSubscriptionDTO> sublist = new List<ClientSubscriptionDTO>();
            List<MarketBase> mktlist = new List<MarketBase>();

            int subid = 0;
            int newSubid = 0;


            foreach (var r in lstsubmkt)
            {
                ClientSubscriptionDTO dto;
                Models.Subscription.SubscriptionDTO sDto;
                List<MarketBase> lstMkt;
                //MarketBase objMbase;
                subid = r.SubscriptionId;
                if (subid != newSubid)
                {
                    dto = new ClientSubscriptionDTO();
                    sDto = new Models.Subscription.SubscriptionDTO();
                    dto.ClientId = r.subscription.ClientId;
                    // dto.subscription = r.subscription;
                    sDto.SubscriptionId = r.SubscriptionId;
                    sDto.Name = r.subscription.Name;
                    sDto.ClientId = r.subscription.ClientId;
                    sDto.CountryId = r.subscription.CountryId;
                    sDto.ServiceId = r.subscription.ServiceId;
                    sDto.DataTypeId = r.subscription.DataTypeId;
                    sDto.SourceId = r.subscription.SourceId;
                    sDto.Country = r.subscription.country.Name;
                    sDto.Service = r.subscription.service.Name;
                    sDto.Data = r.subscription.dataType.Name;
                    sDto.Source = r.subscription.source.Name;
                    sDto.StartDate = r.subscription.StartDate;
                    sDto.EndDate = r.subscription.EndDate;
                    sDto.ServiceTerritoryId = r.subscription.ServiceTerritoryId;
                    sDto.Active = r.subscription.Active;
                    sDto.LastModified = r.subscription.LastModified;
                    sDto.ModifiedBy = r.subscription.ModifiedBy;
                    sDto.serviceTerritory = r.subscription.serviceTerritory;
                    dto.subscription = sDto;
                    var listOfmktid = lstsubmkt.Where(r1 => r1.SubscriptionId == subid && r1.subscription.EndDate.Year >= DateTime.Now.Year).Select(t => t.MarketBaseId);
                    lstMkt = new List<MarketBase>();

                    lstMkt = lstsubmkt.Where(t2 => t2.SubscriptionId == subid).Select(t3 => t3.marketBase).OrderBy(p => p.Name).ThenBy(q => q.Suffix).ToList();

                    dto.MarketBase = lstMkt;
                    sublist.Add(dto);
                    //dto = new ClientSubscriptionDTO();
                    //dto.subscription = r.subscription;

                    //var listOfmktid = lstsubmkt.Where(r1 => r1.SubscriptionId == subid && r1.subscription.EndDate.Year >= DateTime.Now.Year).Select(t => t.MarketBaseId);
                    //lstMkt = new List<MarketBase>();

                    //lstMkt = lstsubmkt.Where(t2 => t2.SubscriptionId == subid).Select(t3 => t3.marketBase).ToList();

                    //dto.MarketBase = lstMkt;
                    //sublist.Add(dto);
                }
                newSubid = r.SubscriptionId;


            }


            var json = JsonConvert.SerializeObject(sublist, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

        [Route("api/subscription/addMarketBase")]
        [HttpPost]
        public HttpResponseMessage addMarketBase([FromBody]JObject request)
        {
            if (request != null)
            {
                int clientID = 0;
                if (request["clientid"] != null)
                {
                    string clientid = Convert.ToString(request["clientid"]);
                    int.TryParse(clientid, out clientID);
                }
                AuthController objAuth = new AuthController();
                if (objAuth.CheckUserClients(clientID) == 0)
                    return Request.CreateResponse(HttpStatusCode.NoContent);

                string subId = request["subscriptionid"].ToString();
                var MktId = request["mktbaseid"].ToList();

                int subscriptionId = 0;
                int.TryParse(subId, out subscriptionId);
                for (int i = 0; i < MktId.Count; i++)
                {
                    int mktBaseid = 0;
                    int.TryParse(MktId[i].ToString(), out mktBaseid);
                    int recCnt = dbContext.subscriptionMarket.Count(p => p.SubscriptionId == subscriptionId && p.MarketBaseId == mktBaseid);
                    if (recCnt <= 0)
                    {
                        dbContext.subscription.Where(x => x.SubscriptionId == subscriptionId).FirstOrDefault().LastModified = DateTime.Now;
                        dbContext.subscriptionMarket.Add(new SubscriptionMarket { SubscriptionId = subscriptionId, MarketBaseId = mktBaseid });
                    }
                }

                dbContext.SaveChanges();
            }
            return Request.CreateResponse(HttpStatusCode.Created);
        }
        [Route("api/subscription/deleteMarketBase")]
        [HttpPost]
        public HttpResponseMessage deleteMarketBase([FromBody]JObject request)
        {
            //HttpContent requestContent = Request.Content;
            //var jsonContent = requestContent.ReadAsStringAsync().Result;
            if (request != null)
            {
                string subId = request["subscriptionid"].ToString();
                string mktbaseid = request["mktbaseid"].ToString();
                int subscriptionId = 0; int markettbaseid = 0;
                int.TryParse(subId, out subscriptionId);
                int.TryParse(mktbaseid, out markettbaseid);
                //delete from queue
                dbContext.Database.ExecuteSqlCommand("Delete from [dbo].[MarketBaseDeleteQueue] Where MarketBaseId=" + markettbaseid + " AND CompleteDeleteFlag=0 AND SubscriptionId=" + subscriptionId + " ");

                SqlParameter paramMarketbaseID = new SqlParameter("@MarketBaseId", markettbaseid);
                SqlParameter paramSubscriptionID = new SqlParameter("@SubscriptionId", subscriptionId);

                int result = dbContext.Database.ExecuteSqlCommand("exec UnsubscribeMarketBase @MarketBaseId,@SubscriptionId", paramMarketbaseID, paramSubscriptionID);
                if (result == -1)
                    {
                        dbContext.subscription.Where(x => x.SubscriptionId == subscriptionId).FirstOrDefault().LastModified = DateTime.Now;
                        dbContext.SaveChanges();
                }
            }


            //Old code
            /*if (request != null)
            {
                using (var transaction = dbContext.Database.BeginTransaction())
                {
                    int clientID = 0;
                    if (request["clientid"] != null)
                    {
                        string clientid = Convert.ToString(request["clientid"]);
                        int.TryParse(clientid, out clientID);
                    }
                    AuthController objAuth = new AuthController();
                    if (objAuth.CheckUserClients(clientID) == 0)
                        return Request.CreateResponse(HttpStatusCode.NoContent);

                    string subId = request["subscriptionid"].ToString();
                    string mktbaseid = request["mktbaseid"].ToString();
                    int subscriptionId = 0; int markettbaseid = 0;
                    int.TryParse(subId, out subscriptionId);
                    int.TryParse(mktbaseid, out markettbaseid);

                    dbContext.subscriptionMarket.RemoveRange(dbContext.subscriptionMarket.Where(x => x.SubscriptionId == subscriptionId && x.MarketBaseId == markettbaseid));

                    //var delList = dbContext.deliverables.Where(p => p.SubscriptionId == subscriptionId).ToList();
                    var delMktList = dbContext.DeliveryMarkets.Where(p => p.deliverables.SubscriptionId == subscriptionId).ToList();
                    List<DeliveryMarket> lstDeleteDelMkt = new List<DeliveryMarket>();
                    //loop through delivery market
                    foreach (var objDel in delMktList)
                    {
                        var mktBaseidList = dbContext.MarketDefinitionBaseMaps.Where(x => x.MarketDefinitionId == objDel.MarketDefId).ToList();
                        foreach (var oMktBase in mktBaseidList)
                        {
                            if (oMktBase.MarketBaseId == markettbaseid)
                            {
                                //delMktList.Remove(objDel);
                                lstDeleteDelMkt.Add(objDel);
                            }
                        }

                    }
                    dbContext.DeliveryMarkets.RemoveRange(lstDeleteDelMkt);

                    dbContext.SaveChanges();
                    transaction.Commit();
                }
            }*/
            return Request.CreateResponse(HttpStatusCode.Created);
        }
        [Route("api/subscription/updateSubscription")]
        [HttpPost]
        public HttpResponseMessage updateSubscription([FromBody]JObject request)
        {
            if (request != null)
            {
                int clientID = 0;
                if (request["clientid"] != null)
                {
                    string clientid = Convert.ToString(request["clientid"]);
                    int.TryParse(clientid, out clientID);
                }
                AuthController objAuth = new AuthController();
                if (objAuth.CheckUserClients(clientID) == 0)
                    return Request.CreateResponse(HttpStatusCode.NoContent);

                string subId = request["subscriptionid"].ToString();
                string fromDate = request["fromdate"].ToString();
                string toDate = request["todate"].ToString();
                int subscriptionId = 0;
                DateTime fDate, tDate;
                int.TryParse(subId, out subscriptionId);
                DateTime.TryParse(fromDate, out fDate);
                DateTime.TryParse(toDate, out tDate);

                Subscription sObj = dbContext.subscription.Where(p => p.SubscriptionId == subscriptionId).SingleOrDefault();
                if (sObj != null)
                {
                    sObj.StartDate = fDate;
                    sObj.EndDate = tDate;
                    sObj.LastModified = DateTime.Now;
                    

                    dbContext.SaveChanges();
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created);
        }

        [Route("api/GetClientSubscriptions")]
        [HttpGet]
        public HttpResponseMessage GetClientSubscriptions(int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit subscription.");

            //List<SubscriptionMarket> lstsubmkt = new List<SubscriptionMarket>();

            //List<ClientSubscriptionDTO> sublist = new List<ClientSubscriptionDTO>();
            //List<MarketBase> mktlist = new List<MarketBase>();

            //var objSub = dbContext.subscription.Where(u => u.ClientId == clientid && u.EndDate.Year >= DateTime.Now.Year).ToList();
            //var subscriptionIdList = (from o in objSub select o.SubscriptionId).ToList();
            //var subscriptionMarket = (from subMkt in dbContext.subscriptionMarket
            //                          where subscriptionIdList.Contains(subMkt.SubscriptionId)
            //                          select subMkt).ToList();

            //var subhistory = (from sub in dbContext.Subscription_History
            //                  where sub.ClientId == clientid && sub.EndDate.Year >= DateTime.Now.Year
            //                  group sub by sub.SubscriptionId into tempGrp
            //                  let maxVersion = tempGrp.Max(x => x.Version)
            //                  select new
            //                  {
            //                      SubscriptionId = tempGrp.Key,
            //                      LastSaved = tempGrp.FirstOrDefault(y => y.Version == maxVersion).LastSaved,
            //                      MaxVer = maxVersion
            //                  }).ToList();

            ////var subHistory = dbContext.Database.SqlQuery<Subscription_History>("select MarketDefId,max(Version) as [Version],Name,Description,ClientId,GuiId,DimensionId,ModifiedDate,UserId,IsSentToTDW,TDWTransferDate,TDWUserId,LastSaved from MarketDefinitions_History where ClientId=" + clientid + " group by MarketDefId,Name");
            //if (objSub != null && objSub.Count > 0)
            //{
            //    foreach (var sub in objSub)
            //    {
            //        ClientSubscriptionDTO dto = new ClientSubscriptionDTO();
            //        Models.Subscription.SubscriptionDTO sDto = new Models.Subscription.SubscriptionDTO();
            //        dto.ClientId = sub.ClientId;
            //        //sub.client.MarketDefinitions = new List<MarketDefinition>();
            //        //dto.subscription = sub;
            //        sDto.SubscriptionId = sub.SubscriptionId;
            //        sDto.Name = sub.Name;
            //        sDto.ClientId = sub.ClientId;
            //        sDto.CountryId = sub.CountryId;
            //        sDto.ServiceId = sub.ServiceId;
            //        sDto.DataTypeId = sub.DataTypeId;
            //        sDto.SourceId = sub.SourceId;
            //        sDto.Country = sub.country.Name;
            //        sDto.Service = sub.service.Name;
            //        sDto.Data = sub.dataType.Name;
            //        sDto.Source = sub.source.Name;
            //        sDto.StartDate = sub.StartDate;
            //        sDto.EndDate = sub.EndDate;
            //        sDto.ServiceTerritoryId = sub.ServiceTerritoryId;
            //        sDto.Active = sub.Active;
            //        sDto.LastModified = sub.LastModified;
            //        sDto.ModifiedBy = sub.ModifiedBy;
            //        sDto.serviceTerritory = sub.serviceTerritory;
            //        var res = subhistory.FirstOrDefault(i => i.SubscriptionId == sub.SubscriptionId);
            //        sDto.Submitted = (res == null || res.LastSaved != sDto.LastModified) ? "No" : "Yes";
            //        dto.subscription = sDto;
            //        //var submket = dbContext.subscriptionMarket.Where(p => p.SubscriptionId == sub.SubscriptionId).ToList();
            //        var submket = subscriptionMarket.Where(p => p.SubscriptionId == sub.SubscriptionId)
            //            .Select(a => a.marketBase).OrderBy(p => p.Name).ThenBy(q => q.Suffix).ToList();

            //        if (submket != null && submket.Count() > 0)
            //        {
            //            dto.MarketBase = submket;
            //            //dto.MarketBase = submket.Select(a => a.marketBase).OrderBy(p => p.Name).ThenBy(q => q.Suffix).ToList();
            //        }
            //        //dto.subscription.client.MarketDefinitions = new List<MarketDefinition>(); 
            //        sublist.Add(dto);
            //        //ClientSubscriptionDTO dto = new ClientSubscriptionDTO();
            //        //dto.ClientId = sub.ClientId;
            //        //sub.client.MarketDefinitions = new List<MarketDefinition>();
            //        //dto.subscription = sub;
            //        //var submket = dbContext.subscriptionMarket.Where(p => p.SubscriptionId == sub.SubscriptionId).ToList();
            //        //if (submket != null && submket.Count() > 0)
            //        //{
            //        //    dto.MarketBase = submket.Select(a => a.marketBase).ToList();
            //        //}
            //        //dto.subscription.client.MarketDefinitions = new List<MarketDefinition>(); 
            //        //sublist.Add(dto);
            //    }
            //}


            // New code
            var clientSubscription = dbContext.subscription
                .GroupJoin(dbContext.subscriptionMarket,
                    s => s.SubscriptionId,
                    m => m.SubscriptionId,
                    (s, m) => new { S = s, M = m })
                .SelectMany(
                    m => m.M.DefaultIfEmpty()
                    , (x, y) => new { Subscription = x.S, SubscriptionMarket = y })
                .GroupJoin(dbContext.Subscription_History,
                    s => s.Subscription.SubscriptionId,
                    h => h.SubscriptionId,
                    (s, h) => new { S = s, H = h })
                .SelectMany(h => h.H.DefaultIfEmpty(),
                    (x, y) => new { Subscription = x.S.Subscription, SubscriptionMarket = x.S.SubscriptionMarket, SubscriptionHistory = y })
                .Where(u => u.Subscription.ClientId == clientid && u.Subscription.EndDate.Year >= DateTime.Now.Year)
                .Select(x => new
                {
                    ClientId = x.Subscription.ClientId,
                    ClientName = x.Subscription.Name,
                    subscription = new Models.Subscription.SubscriptionDTO()
                    {
                        SubscriptionId = x.Subscription.SubscriptionId,
                        Name = x.Subscription.Name,
                        ClientId = x.Subscription.ClientId,
                        CountryId = x.Subscription.CountryId,
                        ServiceId = x.Subscription.ServiceId,
                        DataTypeId = x.Subscription.DataTypeId,
                        SourceId = x.Subscription.SourceId,
                        Country = x.Subscription.country.Name,
                        Service = x.Subscription.service.Name,
                        Data = x.Subscription.dataType.Name,
                        Source = x.Subscription.source.Name,
                        StartDate = x.Subscription.StartDate,
                        EndDate = x.Subscription.EndDate,
                        ServiceTerritoryId = x.Subscription.ServiceTerritoryId,
                        Active = x.Subscription.Active,
                        LastModified = x.Subscription.LastModified,
                        ModifiedBy = x.Subscription.ModifiedBy,
                        serviceTerritory = x.Subscription.serviceTerritory,
                        Submitted = null
                    },
                    SubscriptionMarket = x.SubscriptionMarket,
                    SubscriptionHistory = x.SubscriptionHistory
                })
                .GroupBy(x => new { x.ClientId, x.ClientName, x.subscription })
                .ToList();

            var sublist = clientSubscription.Select(x => new ClientSubscriptionDTO()
            {
                ClientId = x.Key.ClientId,
                ClientName = x.Key.ClientName,
                subscription = new Models.Subscription.SubscriptionDTO()
                {
                    SubscriptionId = x.Key.subscription.SubscriptionId,
                    Name = x.Key.subscription.Name,
                    ClientId = x.Key.subscription.ClientId,
                    CountryId = x.Key.subscription.CountryId,
                    ServiceId = x.Key.subscription.ServiceId,
                    DataTypeId = x.Key.subscription.DataTypeId,
                    SourceId = x.Key.subscription.SourceId,
                    Country = x.Key.subscription.Country,
                    Service = x.Key.subscription.Service,
                    Data = x.Key.subscription.Data,
                    Source = x.Key.subscription.Source,
                    StartDate = x.Key.subscription.StartDate,
                    EndDate = x.Key.subscription.EndDate,
                    ServiceTerritoryId = x.Key.subscription.ServiceTerritoryId,
                    Active = x.Key.subscription.Active,
                    LastModified = x.Key.subscription.LastModified,
                    ModifiedBy = x.Key.subscription.ModifiedBy,
                    serviceTerritory = x.Key.subscription.serviceTerritory,
                    Submitted = x.Select(y => y.SubscriptionHistory).First() == null ? "No" : (x.Select(y => y.SubscriptionHistory).OrderBy(o => o.Version).LastOrDefault().LastSaved < x.Key.subscription.LastModified ? "No" : "Yes")
                },
                MarketBase = (x.Select(y => y.SubscriptionMarket).First() == null || x.Select(y => y.SubscriptionMarket.marketBase) == null) ? null : x.Select(y => GetMarketBase(y.SubscriptionMarket)).Distinct().ToList()
            }).ToList();

            return Request.CreateResponse(HttpStatusCode.OK, sublist);
        }

        static MarketBase GetMarketBase(SubscriptionMarket mkt)
        {
            if (mkt != null && mkt.marketBase != null)
                return mkt.marketBase;
            return null;
        }


        [Route("api/DownloadSubscriptions")]
        [HttpGet]
        public HttpResponseMessage DownloadSubscriptions(int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return new HttpResponseMessage(HttpStatusCode.NotFound);

            List<SubscriptionMarket> lstsubmkt = new List<SubscriptionMarket>();

            List<ClientSubscriptionDTO> sublist = new List<ClientSubscriptionDTO>();
            List<MarketBase> mktlist = new List<MarketBase>();

            DataTable subdcriptionDT = new DataTable();

            var objSub = dbContext.subscription.Where(u => u.ClientId == clientid && u.EndDate.Year >= DateTime.Now.Year).ToList();
            if (objSub != null && objSub.Count > 0)
            {
                foreach (var sub in objSub)
                {
                    ClientSubscriptionDTO dto = new ClientSubscriptionDTO();
                    Models.Subscription.SubscriptionDTO sDto = new Models.Subscription.SubscriptionDTO();
                    dto.ClientId = sub.ClientId;
                    //sub.client.MarketDefinitions = new List<MarketDefinition>();
                    //dto.subscription = sub;
                    sDto.SubscriptionId = sub.SubscriptionId;
                    sDto.Name = sub.Name;
                    sDto.ClientId = sub.ClientId;

                    var cList = dbContext.Clients.Where(z => z.Id == sub.ClientId).ToList().FirstOrDefault();
                    dto.ClientName = cList.Name;
                    //dto.ClientName =
                    sDto.CountryId = sub.CountryId;
                    sDto.ServiceId = sub.ServiceId;
                    sDto.DataTypeId = sub.DataTypeId;
                    sDto.SourceId = sub.SourceId;
                    sDto.Country = sub.country.Name;
                    sDto.Service = sub.service.Name;
                    sDto.Data = sub.dataType.Name;
                    sDto.Source = sub.source.Name;
                    sDto.StartDate = sub.StartDate;
                    sDto.EndDate = sub.EndDate;
                    sDto.ServiceTerritoryId = sub.ServiceTerritoryId;
                    sDto.Active = sub.Active;
                    sDto.LastModified = sub.LastModified;
                    sDto.ModifiedBy = sub.ModifiedBy;
                    sDto.serviceTerritory = sub.serviceTerritory;
                    dto.subscription = sDto;
                    var submket = dbContext.subscriptionMarket.Where(p => p.SubscriptionId == sub.SubscriptionId).ToList();
                    if (submket != null && submket.Count() > 0)
                    {
                        dto.MarketBase = submket.Select(a => a.marketBase).OrderBy(p => p.Name).ThenBy(q => q.Suffix).ToList();

                    }
                    //dto.subscription.client.MarketDefinitions = new List<MarketDefinition>(); 
                    sublist.Add(dto);
                    ////subdcriptionDT = ListToDataTable(sublist);
                    //string xmlString = SerializeXml(sublist);

                    //DataSet ds = new DataSet("New_DataSet");
                    //using (System.Xml.XmlReader reader = System.Xml.XmlReader.Create(new StringReader(xmlString)))
                    //{
                    //    ds.Locale = System.Threading.Thread.CurrentThread.CurrentCulture;
                    //    ds.ReadXml(reader);
                    //    subdcriptionDT = ds.Tables[0];
                    //}
                    subdcriptionDT = BuildsubscriptionDataTable(sublist);

                    //ClientSubscriptionDTO dto = new ClientSubscriptionDTO();
                    //dto.ClientId = sub.ClientId;
                    //sub.client.MarketDefinitions = new List<MarketDefinition>();
                    //dto.subscription = sub;
                    //var submket = dbContext.subscriptionMarket.Where(p => p.SubscriptionId == sub.SubscriptionId).ToList();
                    //if (submket != null && submket.Count() > 0)
                    //{
                    //    dto.MarketBase = submket.Select(a => a.marketBase).ToList();
                    //}
                    //dto.subscription.client.MarketDefinitions = new List<MarketDefinition>(); 
                    //sublist.Add(dto);
                }
            }

            //foreach (var xx in sublist)
            //{

            //    xx.subscription.client.MarketDefinitions.RemoveRange(0, xx.subscription.client.MarketDefinitions.Count);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            MemoryStream stream = new MemoryStream();

            stream = GetExcelStream(subdcriptionDT);
            // Reset Stream Position
            stream.Position = 0;
            result.Content = new StreamContent(stream);

            // Generic Content Header
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            return result;
        }
        //    // response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        //    //response.setHeader("Content-Disposition", "attachment; filename=deployment-definitions.xlsx");

        //    //Set Filename sent to client
        //    result.Content.Headers.ContentDisposition.FileName = "ECPMarketReport.xlsx";
        //    var json = JsonConvert.SerializeObject(sublist, Formatting.Indented,
        //                new JsonSerializerSettings
        //                {
        //                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        //                });

        //    return json;
        //}

        private DataTable BuildsubscriptionDataTable(List<ClientSubscriptionDTO> subcriptionList)
        {
            DataTable Dt = new DataTable();

            Dt.Columns.Add(new DataColumn("clientId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("clientName", typeof(System.String)));

            Dt.Columns.Add(new DataColumn("subscriptionId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("Name", typeof(System.String)));
            //Dt.Columns.Add(new DataColumn("clientId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("CountryId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("ServiceId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("DataTypeId", typeof(System.Int32)));

            Dt.Columns.Add(new DataColumn("Country", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("Service", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("Data", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("Source", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("ServiceTerritoryId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("MarketBaseId", typeof(System.Int32)));
            Dt.Columns.Add(new DataColumn("MarketBaseName", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("MarketBaseDescription", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("DurationFrom", typeof(System.String)));
            Dt.Columns.Add(new DataColumn("DurationTo", typeof(System.String)));

            foreach (ClientSubscriptionDTO csub in subcriptionList)
            {
                if (csub.MarketBase != null && csub.MarketBase.Count > 0)
                {
                    foreach (MarketBase mkb in csub.MarketBase)
                    {
                        DataRow dr = Dt.NewRow();
                        dr["clientId"] = csub.ClientId;
                        dr["clientName"] = csub.ClientName;
                        dr["subscriptionId"] = csub.subscription.SubscriptionId;

                        dr["Name"] = csub.subscription.Name;
                        dr["CountryId"] = csub.subscription.CountryId;
                        dr["ServiceId"] = csub.subscription.ServiceId;
                        dr["DataTypeId"] = csub.subscription.DataTypeId;
                        dr["Country"] = csub.subscription.Country;
                        dr["Service"] = csub.subscription.Service;

                        dr["Data"] = csub.subscription.Data;
                        dr["source"] = csub.subscription.Source;
                        dr["ServiceTerritoryId"] = csub.subscription.ServiceTerritoryId;
                        dr["MarketBaseId"] = mkb.Id;
                        dr["MarketBaseName"] = mkb.Name;
                        dr["MarketBaseDescription"] = mkb.Description;
                        dr["DurationFrom"] = mkb.DurationFrom;
                        dr["DurationTo"] = mkb.DurationTo;
                        Dt.Rows.Add(dr);
                    }
                }
                else
                {
                    DataRow dr = Dt.NewRow();
                    dr["clientId"] = csub.ClientId;
                    dr["clientName"] = csub.ClientName;
                    dr["subscriptionId"] = csub.subscription.SubscriptionId;

                    dr["Name"] = csub.subscription.Name;
                    dr["CountryId"] = csub.subscription.CountryId;
                    dr["ServiceId"] = csub.subscription.ServiceId;
                    dr["DataTypeId"] = csub.subscription.DataTypeId;
                    dr["Country"] = csub.subscription.Country;
                    dr["Service"] = csub.subscription.Service;

                    dr["Data"] = csub.subscription.Data;
                    dr["source"] = csub.subscription.Source;
                    dr["ServiceTerritoryId"] = csub.subscription.ServiceTerritoryId;

                    Dt.Rows.Add(dr);
                }

            }





            return Dt;
        }

        [Route("api/subscription/SubmitSubscription")]
        [HttpPost]
        public HttpResponseMessage SubmitSubscription(int[] subscriptionIds, int UserId)
        {
            foreach (int subscriptionId in subscriptionIds)
            {
                var objClient = dbContext.subscription.Where(u => u.SubscriptionId == subscriptionId).ToList().FirstOrDefault();

                IAuditLog log = AuditFactory.GetInstance(typeof(Subscription).Name);
                log.SaveVersion<Subscription>(objClient, UserId);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/GetMarketBaseForSubscription")]
        [HttpGet]
        public HttpResponseMessage GetMarketBaseForSubscription(int SubscriptionId)
        {
            List<ClientMarketBaseDTO> lstMarketDto = new List<ClientMarketBaseDTO>();
            var submket = (from subMkt in dbContext.subscriptionMarket
                           where subMkt.SubscriptionId == SubscriptionId
                           select subMkt).Select(a => a.marketBase).OrderBy(p => p.Name).ThenBy(q => q.Suffix).ToList();

            foreach (MarketBase b in submket)
            {
                var subBase = (from bse in dbContext.MarketBase_History
                               where bse.MBId == b.Id
                               group bse by bse.MBId into tempGrp
                               let maxVersion = tempGrp.Max(x => x.Version)
                               select new
                               {
                                   MarketBaseId = tempGrp.Key,
                                   LastSaved = tempGrp.FirstOrDefault(y => y.Version == maxVersion).LastSaved,
                                   MaxVer = maxVersion
                               }).FirstOrDefault();

                ClientMarketBaseDTO mDTO = new ClientMarketBaseDTO();
                mDTO.Id = b.Id;
                mDTO.Name = b.Name;
                mDTO.Suffix = b.Suffix;
                mDTO.Submitted = (subBase == null || subBase.LastSaved != b.LastSaved) ? "No" : "Yes";
                //dto.MarkeBaseDto.Add(mDTO);
                lstMarketDto.Add(mDTO);
            }

            return Request.CreateResponse(HttpStatusCode.OK, lstMarketDto);
        }


        [Route("api/subscription/ValidatedeleteMarket")]
        [HttpGet]
        public string ValidatedeleteMarket(int subscriptionId, int markettbaseid, int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return "";

            string result = string.Empty;
            List<string> LstDelName = new List<string>();
            List<string> LstMktName = new List<string>();

            if (subscriptionId > 0 && markettbaseid > 0)
            {

                //int subscriptionId = 0; int markettbaseid = 0;
                //int.TryParse(subId, out subscriptionId);
                //int.TryParse(mktbaseid, out markettbaseid);

                var delMktList = dbContext.DeliveryMarkets.Where(p => p.deliverables.SubscriptionId == subscriptionId).ToList();
                List<DeliveryMarket> lstDeleteDelMkt = new List<DeliveryMarket>();
                //loop through delivery market
                foreach (var objDel in delMktList)
                {
                    var mktBaseidList = dbContext.MarketDefinitionBaseMaps.Where(x => x.MarketDefinitionId == objDel.MarketDefId).ToList();
                    foreach (var oMktBase in mktBaseidList)
                    {
                        if (oMktBase.MarketBaseId == markettbaseid)
                        {
                            string delName = getSubscriptionName(objDel.deliverables);
                            string mrkDefName = objDel.marketDefinition.Name;
                            LstDelName.Add(delName);
                            LstMktName.Add(mrkDefName);
                        }
                    }

                }
                // dbContext.DeliveryMarkets.RemoveRange(lstDeleteDelMkt);

            }
            string res1 = String.Join(",", LstDelName);
            string res2 = String.Join(",", LstMktName);
            if (res1 != "")
                result = res1 + "|" + res2;
            return result;
        }

        [Route("api/subscription/GetListOfMarketForMarketbase")]
        [HttpPost]
        public string GetListOfMarketForMarketbase(int subscriptionId, int marketbaseId, int clientId)
        {
            List<MarketDefinition> MarektDefList = new List<MarketDefinition>();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return JsonConvert.SerializeObject(MarektDefList, Formatting.Indented,
                                         new JsonSerializerSettings
                                         {
                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                         });

            string result = string.Empty;
            List<string> LstDelName = new List<string>();
            List<string> LstMktName = new List<string>();

            if (subscriptionId > 0 && marketbaseId > 0)
            {
                /*var MBList = dbContext.MarketDefinitionBaseMaps.Where(p => p.MarketBaseId == marketbaseId);

                MarektDefList = dbContext.MarketDefinitions
                    .Join(MBList, m => m.Id, mb => mb.MarketDefinitionId, (m, mb) => m)
                    .OrderBy(m => m.Name)
                    .ToList();*/

                MarektDefList = (from M in dbContext.MarketDefinitions
                                 where (from MB in dbContext.MarketDefinitionBaseMaps
                                        where MB.MarketBaseId == marketbaseId
                                        select MB.MarketDefinitionId).Contains(M.Id)
                                 orderby M.Name
                                 select M).ToList();


            }

            var json = JsonConvert.SerializeObject(MarektDefList, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;


        }
        private string getSubscriptionName(Deliverables obj)
        {
            string deliveryName = string.Empty;
            deliveryName = obj.subscription.country.Name + " " + obj.subscription.service.Name + " " + obj.subscription.dataType.Name
                + " " + obj.subscription.source.Name + " ";
            //deliveryName = deliveryName + obj.reportWriter.deliveryType.Name + " " + obj.frequencyType.Name;
            deliveryName = deliveryName + obj.deliveryType.Name + " " + obj.frequencyType.Name;
            return deliveryName;
        }

        public static MemoryStream GetExcelStream(DataTable list1)
        {
            ExcelPackage pck = new ExcelPackage();

            // get the handle to the existing worksheet
            // Dictionary<string, string> dicRepParameters = getReportParameters(FieldList);
            //var hdrRange = repParameter.Cells["A1"].LoadFromCollection(dicRepParameters);
            var wsData = pck.Workbook.Worksheets.Add("Subscription Details");
            var dataRange = wsData.Cells["A1"].LoadFromDataTable(list1, true);

            //var dataRange = wsData.Cells["A1"].LoadFromCollection
            //        (from s in list1
            //         select s,
            //       true);


            var headerCells = wsData.Cells[1, 1, 1, wsData.Dimension.End.Column];
            var headerFont = headerCells.Style.Font;
            headerFont.Bold = true;
            dataRange.AutoFitColumns();
            pck.Save();
            MemoryStream output = new MemoryStream();
            pck.SaveAs(output);
            return output;
        }
    }


}
