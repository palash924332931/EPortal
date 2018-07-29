using System.Linq;
using System.Web.Http;
using Newtonsoft.Json;
using System.Web.Http.Cors;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using IMS.EverestPortal.API.DAL;
using System.Net.Http;
using System;
using IMS.EverestPortal.API.Models;
using System.Collections.Generic;
using System.Net;
using IMS.EverestPortal.API.Audit;
using System.Threading.Tasks;
using IMS.EverestPortal.API.Models.Autocomplete;
using System.Security.Claims;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class MarketBaseCreateController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();
        string ConnectionString = "EverestPortalConnection";

        [Route("api/MarketBaseCreate/GetAvailablePackList")]
        [HttpGet]
        public HttpResponseMessage GetAvailablePackList()
        {

            string jsonContent = @"SELECT DISTINCT Pack_Description, PFC,  Org_Long_Name AS Manufacturer, ATC4_Code, NEC4_Code from DIMProduct_Expanded";

            DataTable packMarketBase = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(jsonContent, conn))
                {
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.Text;
                        da.Fill(packMarketBase);
                    }

                }
            }
            /* var json = JsonConvert.SerializeObject(packMarketBase, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });*/
            return Request.CreateResponse(HttpStatusCode.OK, packMarketBase);



        }
        [Route("api/MarketBaseCreate/SaveMarketBasePacks")]
        [HttpPost]
        public string SaveMarketBasePacks()
        {
            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());

            if (jsonContent.Trim() != string.Empty)
            {
                var marketBase = JsonConvert.DeserializeObject<MarketBase>(jsonContent);

                using (var db = new EverestPortalContext())
                {
                    if (marketBase.Id == 0)
                    {
                        marketBase.ModifiedBy = uid;
                        marketBase.LastModified = DateTime.Now;
                        db.MarketBases.Add(marketBase);

                        db.SaveChanges();
                    }
                    else
                    {
                        MarketBase marketBaseUpdate = db.MarketBases.Where(m => m.Id == marketBase.Id).SingleOrDefault();
                        marketBaseUpdate.Name = marketBase.Name;
                        marketBaseUpdate.Suffix = marketBase.Suffix;
                        marketBaseUpdate.Description = marketBase.Description;
                        marketBaseUpdate.DurationTo = marketBase.DurationTo;
                        marketBaseUpdate.DurationFrom = marketBase.DurationFrom;
                        db.SaveChanges();

                        int filterID = marketBase.Filters[0].Id;
                        BaseFilter baseFilterUpdate = db.BaseFilters.Where(m => m.Id == filterID).SingleOrDefault();
                        baseFilterUpdate.Criteria = marketBase.Filters[0].Criteria;
                        baseFilterUpdate.IsBaseFilterType = marketBase.Filters[0].IsBaseFilterType;
                        baseFilterUpdate.IsEnabled = marketBase.Filters[0].IsEnabled;
                        baseFilterUpdate.IsRestricted = marketBase.Filters[0].IsRestricted;
                        baseFilterUpdate.MarketBaseId = marketBase.Id;
                        baseFilterUpdate.Name = marketBase.Filters[0].Name;
                        baseFilterUpdate.Values = marketBase.Filters[0].Values;

                        marketBaseUpdate.LastModified = DateTime.Now;
                        marketBaseUpdate.ModifiedBy = uid;

                        db.SaveChanges();
                    }
                }
            }
            return "saved";
        }

        [Route("api/MarketBaseCreate/GetMarketBasePacks")]
        [HttpGet]
        public HttpResponseMessage GetMarketBasePacks(int id, int clientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit marketbase.");

            using (var db = new EverestPortalContext())
            {
                var marketBase = db.MarketBases.Where(m => m.Id == id).ToList<MarketBase>();

                if (marketBase == null || marketBase.Count() < 1)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "This marketbase is not available, please try another.");
                }

                //to get dimension list
                var dimensionList = _db.Database.SqlQuery<DimensionBaseMap>("dbo.GetDimensionBaseMaps @pMarketBaseId", new SqlParameter("pMarketBaseId", id)).ToList();
                //to get PxR List
                var pxrList = _db.Database.SqlQuery<PxR>("select Id, MktCode as MarketCode, MktName as MarketName,MarketBaseId as MarketbaseId from MIP.MKTPxRBaseMap Where MarketBaseId=" + id).ToList();
                var marketbaseDetails = new { MarketBase = marketBase, Dimension = dimensionList, PxRList = pxrList };
                var json = JsonConvert.SerializeObject(marketbaseDetails, Formatting.Indented,
                       new JsonSerializerSettings
                       {
                           ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                       });

                return Request.CreateResponse(HttpStatusCode.OK, json);
            }
        }

        [Route("api/MarketBaseCreate/SaveMarketBase")]
        [HttpPost]
        public async Task<string> SaveMarketBase(int ClientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return "";
            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            Guid Id = Guid.NewGuid();
            if (jsonContent.Trim() != string.Empty)
            {
                var marketBaseDetails = JsonConvert.DeserializeObject<MarketbaseDetails>(jsonContent);
                List<DimensionBaseMap> Dimension = marketBaseDetails.Dimension;//to get dimension seperatly.
                List<PxR> PxRCollection = marketBaseDetails.PxR;//to get dimension seperatly.

                MarketBase marketBase = marketBaseDetails.MarketBase;
                marketBase.GuiId = Id.ToString();
                marketBase.LastSaved = DateTime.Now;
                using (var db = new EverestPortalContext())
                {
                    db.MarketBases.Add(marketBase);
                    db.SaveChanges();

                    //to update new marketbase Id
                    await SaveDimensionBaseMap(marketBase.Id, Dimension);
                    await SavePxRBaseMap(marketBase.Id, PxRCollection);
                }
            }
            var objClient = _db.MarketBases.Where(u => u.GuiId == Id.ToString()).ToList<MarketBase>();

            ClientMarketBases clientMarketBases = new ClientMarketBases();
            clientMarketBases.ClientId = ClientId;
            clientMarketBases.MarketBaseId = objClient.First().Id;
            using (var db = new EverestPortalContext())
            {
                db.ClientMarketBases.Add(clientMarketBases);
                db.SaveChanges();
            }

            //to create new version
            SubmitMarketbaseDetailsInformation(clientMarketBases.MarketBaseId);


             var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });


            return json;
        }
        [Route("api/GetClientName")]
        [HttpGet]
        public string GetClientName(int ClientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return "";

            var objClient = _db.Clients
                            .Where(u => u.Id == ClientId)
                            .Select(u => u.Name);


            var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

        [Route("api/MarketBaseCreate/EditMarketBase")]
        [HttpPost]
        public async Task<HttpResponseMessage> EditMarketBase(int ClientId, int MarketBaseId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit this marketbase");

            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            // var marketBase = JsonConvert.DeserializeObject<MarketBase>(jsonContent);

            var marketBaseDetails = JsonConvert.DeserializeObject<MarketbaseDetails>(jsonContent);
            List<DimensionBaseMap> Dimension = marketBaseDetails.Dimension;//to get dimension seperatly.
            List<PxR> PxRCollection = marketBaseDetails.PxR;//to get PxR seperatly.
            MarketBase marketBase = marketBaseDetails.MarketBase;

            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());

            Guid Id = Guid.NewGuid();

            if (jsonContent.Trim() != string.Empty)
            {
                MarketBase MBObj = null;
                using (var db = new EverestPortalContext())
                {
                    var oldBaseFilter = db.BaseFilters.Where(i => i.MarketBaseId == MarketBaseId).ToList();
                    if (oldBaseFilter != null)
                    {
                        db.BaseFilters.RemoveRange(oldBaseFilter);
                        db.SaveChanges();
                    }

                    MBObj = db.MarketBases.Where(i => i.Id == MarketBaseId).FirstOrDefault();

                    if (MBObj != null)
                    {

                        MBObj.BaseType = marketBase.BaseType;
                        MBObj.Description = marketBase.Description;
                        MBObj.DurationFrom = marketBase.DurationFrom;
                        MBObj.DurationTo = marketBase.DurationTo;
                        MBObj.Name = marketBase.Name;
                        MBObj.Suffix = marketBase.Suffix;
                        MBObj.LastSaved = DateTime.Now;
                        foreach (BaseFilter fil in marketBase.Filters)
                        {

                            BaseFilter obj = fil;
                            obj.MarketBaseId = MarketBaseId;
                            MBObj.Filters.Add(obj);

                        }
                        MBObj.LastModified = DateTime.Now;
                        MBObj.ModifiedBy = uid;

                    }
                    else
                    {
                        marketBase.GuiId = Id.ToString();
                        // marketBase.LastSaved = DateTime.Now;
                        marketBase.LastModified = DateTime.Now;
                        marketBase.ModifiedBy = uid;
                        db.MarketBases.Add(marketBase);
                    }

                    db.SaveChanges();
                    //to save dimension base map
                    await SaveDimensionBaseMap(MarketBaseId, Dimension);
                    await SavePxRBaseMap(MarketBaseId, PxRCollection);
                }
            }

            var objClient = _db.MarketBases.Where(u => u.Id == MarketBaseId).ToList<MarketBase>().FirstOrDefault();

            // place the request in queue
            var result = _db.Database.SqlQuery<string>("exec PutInMarketBaseQueue " + MarketBaseId+","+ uid).FirstOrDefault();

            var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return Request.CreateResponse(HttpStatusCode.OK, json);

        }

        [Route("api/MarketBaseCreate/SubmitMarketBase")]
        [HttpPost]
        public HttpResponseMessage SubmitMarketBase(int[] MarketBaseIds, int userId)
        {
            foreach (int MarketBaseId in MarketBaseIds)
            {
                var objClient = _db.MarketBases.Where(u => u.Id == MarketBaseId).ToList<MarketBase>().FirstOrDefault();
                IAuditLog log = AuditFactory.GetInstance(typeof(MarketBase).Name);
                log.SaveVersion<MarketBase>(objClient, userId);
            }
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/MarketBaseCreate/GetEffectedMarketDefName")]
        [HttpGet]
        public string GetEffectedMarketDefName(int MarketBaseId, int ClientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return "";

            DataTable marketDefName = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("GetEffectedMarketDefName", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@MarketBaseId", SqlDbType.Int));
                    cmd.Parameters["@MarketBaseId"].Value = MarketBaseId; //hardcoded for now

                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        da.Fill(marketDefName);
                    }

                }
            }

            string name = "";
            for (var x = 0; x < marketDefName.Rows.Count; x++)
            {
                name = name + marketDefName.Rows[x]["NAME"] + ", ";
            }

            if (name.Length < 1)
            {
                return name;
            }
            else
            {
                return name.Substring(0, name.Length - 2);
            }
        }
        [Route("api/MarketBaseCreate/GetDefaultStartDate")]
        [HttpGet]
        public string GetDefaultStartDate()
        {
            using (var db = new EverestPortalContext())
            {

                var result = db.Database.SqlQuery<DateTime>("Select dbo.fnGetDefaultStartDate()");

                var json = result.First().ToString("yyyy-MM-dd");
                return json.ToString();
            }
        }
        public async Task<string> SaveDimensionBaseMap(int MarketbaseId, List<DimensionBaseMap> DimensionCollection)
        {
            var packsDt = new DataTable();
            packsDt.Columns.Add("DimensionId", typeof(int));
            packsDt.Columns.Add("MarketBaseId", typeof(int));


            foreach (var item in DimensionCollection)
            {
                item.MarketbaseId = MarketbaseId;
                packsDt.Rows.Add(item.DimensionId, item.MarketbaseId);
            }

            SqlParameter mbaseID = new SqlParameter("@marektbaseId", MarketbaseId);
            SqlParameter paramDimensions = new SqlParameter("@TVP", packsDt);
            paramDimensions.SqlDbType = System.Data.SqlDbType.Structured;
            paramDimensions.TypeName = "TYPDimensionBaseMap";
            //db.Database.ExecuteSqlCommand("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);
            await _db.Database.ExecuteSqlCommandAsync("exec EditDimensionBaseMap @marektbaseId,@TVP", mbaseID, paramDimensions);
            return "";
        }

        public async Task<string> SavePxRBaseMap(int MarketbaseId, List<PxR> PxRCollection)
        {
            var packsDt = new DataTable();
            packsDt.Columns.Add("MktCode", typeof(string));
            packsDt.Columns.Add("MktName", typeof(string));
            packsDt.Columns.Add("MarketBaseId", typeof(int));


            foreach (var item in PxRCollection)
            {
                item.MarketbaseId = MarketbaseId;
                packsDt.Rows.Add(item.MarketCode, item.MarketName, item.MarketbaseId);
            }

            SqlParameter mbaseID = new SqlParameter("@marektbaseId", MarketbaseId);
            SqlParameter paramDimensions = new SqlParameter("@TVP", packsDt);
            paramDimensions.SqlDbType = System.Data.SqlDbType.Structured;
            paramDimensions.TypeName = "TYPPxRBaseMap";
            //db.Database.ExecuteSqlCommand("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);
            await _db.Database.ExecuteSqlCommandAsync("exec EditPxRBaseMap @marektbaseId,@TVP", mbaseID, paramDimensions);
            return "";
        }

        [Route("api/MarketBaseCreate/checkForMarketbaseDuplication")]
        [HttpGet]
        public Boolean checkForMarketbaseDuplication(int MarketbaseId, int ClientId, string MarketbaseName)
        {
            using (var db = new EverestPortalContext())
            {
                var data = db.Database.SqlQuery<int>("Select Count(*) as result from marketbases where name +' '+suffix ='" + MarketbaseName + "' AND Id<>" + MarketbaseId + " AND Id in (Select MarketbaseId from ClientMarketBases Where ClientId=" + ClientId + ")").FirstOrDefault();

                if (data == 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        [Route("api/DeleteMarketbase")]
        [HttpGet]
        public async Task<HttpResponseMessage> DeleteMarketbase(int ClientId, int MarketbaseId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/delete this marketbase");
            // place the request in queue
            try
            {

                var result = _db.Database.SqlQuery<string>("exec PutInMarketBaseDeleteQueue " + MarketbaseId + "," + 1).FirstOrDefault();
                var json = JsonConvert.SerializeObject(result, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            });

                return Request.CreateResponse(HttpStatusCode.OK, json);

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/delete this marketbase");
            }

        }


        public void SubmitMarketbaseDetailsInformation(int MarketBaseId)
        {
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            var objClient = _db.MarketBases.Where(u => u.Id == MarketBaseId).ToList<MarketBase>().FirstOrDefault();
                IAuditLog log = AuditFactory.GetInstance(typeof(MarketBase).Name);
                log.SaveVersion<MarketBase>(objClient, uid);
            
        }


    }

    public class MarketbaseDetails
    {
        public MarketBase MarketBase { set; get; }
        public List<DimensionBaseMap> Dimension { set; get; }
        public List<PxR> PxR { set; get; }
    }
}
