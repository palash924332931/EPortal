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
using System.Data.Entity.Migrations;
using IMS.EverestPortal.API.Models.Deliverable;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Net;
using IMS.EverestPortal.API.Audit;
using IMS.EverestPortal.API.Models.Grouping;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class MarketViewController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();

        //[Route("api/MarketBase")]
        //[HttpGet]
        //public MarketBase GetResult(int id)
        //{
        //    MarketBase marketBase = _db.MarketBases.Where(u => u.Id == id).FirstOrDefault();
        //    //return marketBase;
        //    return marketBase;
        //}

        // GET: api/Test/5
        string ConnectionString = "EverestPortalConnection";
        public string Get(int id)
        {
            var objClient = _db.MarketBases.Where(u => u.Id == id).FirstOrDefault();
            var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;

        }

        [Route("api/Test/GetFilter")]
        public string GetFilter(int Id)
        {
            var objClient = _db.BaseFilters.Where(u => u.Id == Id).FirstOrDefault();
            var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;

        }

        [Route("api/Client")]
        [HttpGet]
        public HttpResponseMessage GetClient(int id)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(id) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view market definitions.");

            var objMarketDefinition = _db.Database.SqlQuery<MarketDefinition>("Select MarketDefinitions.Id as Id, MarketDefinitions.DimensionId as DimensionId, MarketDefinitions.Name as Name, MarketDefinitions.Description as Description, MarketDefinitions.ClientId as ClientId, MarketDefinitions.GuiId as GuiId,LastSaved, LastModified, ModifiedBy from MarketDefinitions Where clientId=" + id + " order by name").ToList();
            var objMarketDefinitionBaseMap = _db.Database.SqlQuery<MarketDefinitionBaseMap>("Select MarketDefinitionBaseMaps.Id as Id, MarketDefinitionBaseMaps.Name as Name, MarketDefinitionBaseMaps.DataRefreshType as DataRefreshType,(Select count(*) from AdditionalFilters Where MarketDefinitionBaseMapId=MarketDefinitionBaseMaps.Id) as MarketBaseId, MarketDefinitionId  from MarketDefinitionBaseMaps Where marketDefinitionId in (Select MarketDefinitions.Id from MarketDefinitions Where clientId = " + id + ")").ToList();
            if (objMarketDefinition.Count() > 0)
            {
                objMarketDefinition.ForEach(record =>
                {
                    if (record.Id != null)
                    {
                        //for technical issue filter count value put in MarketDefinitionId
                        //var objMarketDefinitionBaseMap = _db.Database.SqlQuery<MarketDefinitionBaseMap>("Select MarketDefinitionBaseMaps.Id as Id, MarketDefinitionBaseMaps.Name as Name,MarketDefinitionBaseMaps.MarketBaseId as MarketBaseId, MarketDefinitionBaseMaps.DataRefreshType as DataRefreshType,(Select count(*) from AdditionalFilters Where MarketDefinitionBaseMapId=MarketDefinitionBaseMaps.Id) as MarketDefinitionId  from MarketDefinitionBaseMaps Where marketDefinitionId=" + record.Id + "").ToList();
                        if (objMarketDefinitionBaseMap.Count() > 0)
                        {
                            record.MarketDefinitionBaseMaps = objMarketDefinitionBaseMap.Where(bm=>bm.MarketDefinitionId==record.Id).ToList();
                        }
                    }
                });
            }         

            return Request.CreateResponse(HttpStatusCode.OK, objMarketDefinition);
        }

        [Route("api/GetMarketDefByClient")]
        [HttpGet]
        public HttpResponseMessage GetMarketDefByClient(int id)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(id) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view market definitions.");

            var marketDef = (from mar in _db.MarketDefinitions
                             where mar.ClientId == id
                             select mar).ToList();
            var marketDefHistory = (from sub in _db.MarketDefinitions_History
                                    where sub.ClientId == id
                                    group sub by sub.MarketDefId into tempGrp
                                    let maxVersion = tempGrp.Max(x => x.Version)
                                    select new
                                    {
                                        MarketDefId = tempGrp.Key,
                                        LastSaved = tempGrp.FirstOrDefault(y => y.Version == maxVersion).LastSaved,
                                        MaxVer = maxVersion
                                    }).ToList();

            MarketDefDTO objDTO;
            List<MarketDefDTO> lstMarketDTO = new List<MarketDefDTO>();
            foreach (MarketDefinition marDef in marketDef)
            {
                objDTO = new MarketDefDTO();
                marDef.CopyProperties(objDTO);
                objDTO.Id = marDef.Id;
                var res = marketDefHistory.FirstOrDefault(i => i.MarketDefId == marDef.Id);
                objDTO.Submitted = (res == null || res.LastSaved != marDef.LastSaved) ? "No" : "Yes";

                lstMarketDTO.Add(objDTO);
            }
            List<MarketDefDTO> notSubmitted = lstMarketDTO.Where(t => t.Submitted == "No").ToList();
            notSubmitted.Sort(CompareByName);
            List<MarketDefDTO> submitted = lstMarketDTO.Where(t => t.Submitted == "Yes").ToList();
            submitted.Sort(CompareByName);
            List<MarketDefDTO> finalList = new List<MarketDefDTO>();
            finalList.AddRange(notSubmitted); finalList.AddRange(submitted);

            return Request.CreateResponse(HttpStatusCode.OK, finalList);
        }

        private int CompareByName(MarketDefDTO market1, MarketDefDTO market2)
        {
            return string.Compare(market1.Name, market2.Name);
        }

        [Route("api/Clients")]
        [HttpGet]
        public string GetClients(int uid)
        {
            var identity = (ClaimsIdentity)User.Identity;
            //force to use login id, can not pass other value for security reasons.
            var cid = identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString();
            uid = Convert.ToInt32(cid);

            var userTypeId = _db.Users.Where(p => p.UserID == uid).SingleOrDefault().UserTypeID;
            if (userTypeId == 1)//internal users
            {
                var objMyClient = (from uc in _db.userClient
                                   join u in _db.Users on uc.UserID equals u.UserID
                                   join c in _db.Clients on uc.ClientID equals c.Id
                                   where u.UserID == uid
                                   select new { Id = c.Id, Name = c.Name, IsMyClient = 1, MarketDefinitions = "" });
                List<int> tempIdList = objMyClient.Select(q => q.Id).ToList();

                var objAllClient = (from x in _db.Clients.Where(q => !tempIdList.Contains(q.Id))
                                    select new { Id = x.Id, Name = x.Name, IsMyClient = 0, MarketDefinitions = "" });


                var objClient = objMyClient.Concat(objAllClient);

                var json = JsonConvert.SerializeObject(objClient.OrderBy(c => c.Name), Formatting.Indented,
                       new JsonSerializerSettings
                       {
                           ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                       });
                return json;
            }

            else
            {
                var objClient = from uc in _db.userClient
                                join u in _db.Users on uc.UserID equals u.UserID
                                join c in _db.Clients on uc.ClientID equals c.Id
                                where u.UserID == uid
                                select new { Id = c.Id, Name = c.Name, IsMyClient = 1, MarketDefinitions = "" };
                var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                           new JsonSerializerSettings
                           {
                               ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                           });
                return json;
            }

        }



        [Route("api/ClientMarketBase")]
        [HttpGet]
        public string ClientMarketBase(int id)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(id) == 0)
                return "";

            DataTable clientMarketBase = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("GetClientMarketBase", conn))
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

            var json = JsonConvert.SerializeObject(clientMarketBase, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        [Route("api/GetMarketBases")]
        [HttpGet]
        public HttpResponseMessage GetMarketBases(int ClientId, int MarketDefId, string Action)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit marketbases.");

            DataTable clientMarketBase = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("prGetMarketBase", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@ClientId", SqlDbType.Int)).Value = ClientId;
                    cmd.Parameters.Add(new SqlParameter("@MarketDefId", SqlDbType.Int)).Value = MarketDefId;
                    cmd.Parameters.Add(new SqlParameter("@Type", SqlDbType.NVarChar, 100)).Value = Action;
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        da.Fill(clientMarketBase);
                    }

                }
            }

           /* var json = JsonConvert.SerializeObject(clientMarketBase, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });*/

            return Request.CreateResponse(HttpStatusCode.OK, clientMarketBase);
        }

        [Route("api/StaticAvailablePackList")]
        [HttpPost]
        public HttpResponseMessage GetStaticAvailablePackList(int id)
        {
            HttpContent requestContent = Request.Content;
            string jsonContent = requestContent.ReadAsStringAsync().Result;

            if (jsonContent == "")
            {
                jsonContent = @"SELECT DISTINCT TOP 0 * from DIMProduct_Expanded";
            }


            DataTable packMarketBase = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
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

            /*var json = JsonConvert.SerializeObject(packMarketBase, Formatting.Indented,
                     new JsonSerializerSettings
                     {
                         ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                     });*/

            return Request.CreateResponse(HttpStatusCode.OK, packMarketBase);
        }

        [Route("api/DynamicAvailablePackList")]
        [HttpPost]
        public HttpResponseMessage GetDynamicAvailablePackList(int id)
        {
            HttpContent requestContent = Request.Content;
            string jsonContent = requestContent.ReadAsStringAsync().Result;

            if (jsonContent == "")
            {
                jsonContent = @"SELECT DISTINCT TOP 0 * from DIMProduct_Expanded";
            }
            DataTable packMarketBase = new DataTable();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
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

        [Route("api/checkForMarketDefDuplication")]
        [HttpGet]
        public Boolean checkForMarketDefDuplication(int ClientId, string MarketDefName)
        {
            var data = _db.MarketDefinitions.Where(u => u.Name.Equals(MarketDefName, StringComparison.CurrentCultureIgnoreCase) && u.ClientId == ClientId).FirstOrDefault();

            if (data != null)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        [Route("api/checkForMarketDefDuplication")]
        [HttpGet]
        public Boolean checkForMarketDefDuplication(int ClientId, int MarketDefId, string MarketDefName)
        {
            var data = _db.MarketDefinitions.Where(u => u.Name.Equals(MarketDefName, StringComparison.CurrentCultureIgnoreCase) && u.ClientId == ClientId && u.Id != MarketDefId).FirstOrDefault();

            if (data != null)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        [Route("api/getClientMarketDef")]
        [HttpGet]
        public HttpResponseMessage getClientMarketDef(int ClientId, int MarketDefId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit this market");
            }

            var entity = _db.MarketDefinitions.FirstOrDefault(m => m.Id == MarketDefId && m.ClientId == ClientId);
            if (entity == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, "This market is not available, please try another.");
            }
            else
            {
                MarketDefinition marketDef = _db.Database.SqlQuery<MarketDefinition>("Select * from MarketDefinitions Where ID=" + MarketDefId).FirstOrDefault();
                var marketDefBaseMaps = _db.MarketDefinitionBaseMaps.Where(MD => MD.MarketDefinitionId == MarketDefId).ToList();
                //List<MarketDefinitionPack> marketDefinitionPacks = _db.Database.SqlQuery<MarketDefinitionPack>("Select * from MarketDefinitionPacks Where MarketDefinitionID="+ MarketDefId).ToList();
                marketDef.MarketDefinitionBaseMaps = marketDefBaseMaps;
                //marketDef.MarketDefinitionPacks = marketDefinitionPacks;
                var json = JsonConvert.SerializeObject(marketDef, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            });

                return Request.CreateResponse(HttpStatusCode.OK, marketDef);
            }
        }

        [Route("api/getMarketDefinitionPacks")]
        [HttpGet]
        public HttpResponseMessage getMarketDefinitionPacks(int ClientId, int MarketDefId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view/edit Market definition packs.");
            }

            //JsonConvert.SerializeObject(marketDefinitionPacks)
            // List<MarketDefinitionPack> marketDefinitionPacks = _db.Database.SqlQuery<MarketDefinitionPack>("Select * from MarketDefinitionPacks Where MarketDefinitionID=" + MarketDefId).ToList();
            List<Packs> marketDefinitionPacks = _db.Database.SqlQuery<Packs>("Select * from vwMarketDefinitionPacks Where MarketDefinitionID=" + MarketDefId).ToList();
            return Request.CreateResponse(HttpStatusCode.OK, marketDefinitionPacks);

        }


        [Route("api/saveClientMarketDef")]
        [HttpPost]
        public async Task<HttpResponseMessage> saveClientMarketDef(int ID)
        {

            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            Guid Id = Guid.NewGuid();
            int MarketDefId;
            var client = JsonConvert.DeserializeObject<Client[]>(jsonContent);
            var marketDefinitionPacks = client[0].MarketDefinitions[0].MarketDefinitionPacks;//store Packs
                                                                                             //to remove marketdefinition packs from Marketdefinition model
            client[0].MarketDefinitions[0].MarketDefinitionPacks = null;
            //to clear market base when client save market base
            for (var i = 0; i < client[0].MarketDefinitions[0].MarketDefinitionBaseMaps.Count(); i++)
            {
                client[0].MarketDefinitions[0].MarketDefinitionBaseMaps[i].MarketBase = null;

            }

            client[0].MarketDefinitions[0].GuiId = Id.ToString();
            client[0].MarketDefinitions[0].LastModified = DateTime.Now;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            client[0].MarketDefinitions[0].ModifiedBy = uid;
            using (var db = new EverestPortalContext())
            {
                _db.MarketDefinitions.Add(client[0].MarketDefinitions[0]).ClientId = ID;
                //_db.SaveChanges();
                await _db.SaveChangesAsync();
                MarketDefId = client[0].MarketDefinitions[0].Id;
            }





            var packsDt = new DataTable();
            packsDt.Columns.Add("Pack", typeof(string));
            packsDt.Columns.Add("MarketBase", typeof(string));
            packsDt.Columns.Add("MarketBaseId", typeof(string));
            packsDt.Columns.Add("GroupNumber", typeof(string));
            packsDt.Columns.Add("GroupName", typeof(string));
            packsDt.Columns.Add("Factor", typeof(string));
            packsDt.Columns.Add("PFC", typeof(string));
            packsDt.Columns.Add("Manufacturer", typeof(string));
            packsDt.Columns.Add("ATC4", typeof(string));
            packsDt.Columns.Add("NEC4", typeof(string));
            packsDt.Columns.Add("DataRefreshType", typeof(string));
            packsDt.Columns.Add("StateStatus", typeof(string));
            packsDt.Columns.Add("MarketDefinitionId", typeof(int));
            packsDt.Columns.Add("Alignment", typeof(string));
            packsDt.Columns.Add("Product", typeof(string));
            packsDt.Columns.Add("ChangeFlag", typeof(string));
            packsDt.Columns.Add("Molecule", typeof(string));


            foreach (var item in marketDefinitionPacks)
            {
                item.MarketDefinitionId = MarketDefId;
                packsDt.Rows.Add(item.Pack, item.MarketBase, item.MarketBaseId, item.GroupNumber, item.GroupName, item.Factor, item.PFC, item.Manufacturer, item.ATC4, item.NEC4, item.DataRefreshType, item.StateStatus, MarketDefId, item.Alignment, item.Product, item.ChangeFlag, item.Molecule);
            }

            SqlParameter paramMarketDefinitionID = new SqlParameter("@marketdefinitionid", MarketDefId);
            SqlParameter paramPacks = new SqlParameter("@TVP", packsDt);
            paramPacks.SqlDbType = System.Data.SqlDbType.Structured;
            paramPacks.TypeName = "TYP_MarketDefinitionPacks";
            //_db.Database.ExecuteSqlCommand("exec  EditMarketDefinition @marketdefinitionid,@TVP", paramMarketDefinitionID, paramPacks);
            await _db.Database.ExecuteSqlCommandAsync("exec  EditMarketDefinition @marketdefinitionid,@TVP", paramMarketDefinitionID, paramPacks);


            var objClient = _db.MarketDefinitions.Where(u => u.ClientId == ID && u.GuiId == Id.ToString()).FirstOrDefault();
            /*var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });*/

            return Request.CreateResponse(HttpStatusCode.OK, objClient);

        }

        [Route("api/editClientMarketDef")]
        [HttpPost]
        public async Task<HttpResponseMessage> editClientMarketDef(int ClientId, int MarketDefId)
        {

            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;

            var client = JsonConvert.DeserializeObject<Client[]>(jsonContent);
            client[0].MarketDefinitions[0].Id = MarketDefId;
            client[0].MarketDefinitions[0].ClientId = ClientId;
            //client[0].MarketDefinitions[0].LastSaved = DateTime.Now;

            //to clear market base when client save market base
            for (var i = 0; i < client[0].MarketDefinitions[0].MarketDefinitionBaseMaps.Count(); i++)
            {
                client[0].MarketDefinitions[0].MarketDefinitionBaseMaps[i].MarketBase = null;
                client[0].MarketDefinitions[0].MarketDefinitionBaseMaps[i].MarketDefinitionId = MarketDefId;

            }

            //to set market definition ID of every pack
            for (var i = 0; i < client[0].MarketDefinitions[0].MarketDefinitionPacks.Count(); i++)
            {
                client[0].MarketDefinitions[0].MarketDefinitionPacks[i].MarketDefinitionId = MarketDefId;

            }

            //to clean Market definitionbase map
            SqlParameter paramMarketID = new SqlParameter("@MarketDefID", MarketDefId);
            //_db.Database.ExecuteSqlCommand("exec DeleteMarketDefinitionBaseMap @MarketDefID", paramMarketID);
            await _db.Database.ExecuteSqlCommandAsync("exec DeleteMarketDefinitionBaseMap @MarketDefID", paramMarketID);

            client[0].MarketDefinitions[0].LastModified = DateTime.Now;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            client[0].MarketDefinitions[0].ModifiedBy = uid;

            _db.MarketDefinitions.AddOrUpdate(client[0].MarketDefinitions[0]);
            //_db.MarketDefinitionPacks.RemoveRange(_db.MarketDefinitionPacks.Where(x => x.MarketDefinitionId == MarketDefId));
            _db.MarketDefinitionBaseMaps.AddRange(client[0].MarketDefinitions[0].MarketDefinitionBaseMaps);
            //_db.MarketDefinitionPacks.AddRange(client[0].MarketDefinitions[0].MarketDefinitionPacks);
            _db.Configuration.AutoDetectChangesEnabled = false;
            //_db.SaveChanges();
            await _db.SaveChangesAsync();


            var packsDt = new DataTable();
            packsDt.Columns.Add("Pack", typeof(string));
            packsDt.Columns.Add("MarketBase", typeof(string));
            packsDt.Columns.Add("MarketBaseId", typeof(string));
            packsDt.Columns.Add("GroupNumber", typeof(string));
            packsDt.Columns.Add("GroupName", typeof(string));
            packsDt.Columns.Add("Factor", typeof(string));
            packsDt.Columns.Add("PFC", typeof(string));
            packsDt.Columns.Add("Manufacturer", typeof(string));
            packsDt.Columns.Add("ATC4", typeof(string));
            packsDt.Columns.Add("NEC4", typeof(string));
            packsDt.Columns.Add("DataRefreshType", typeof(string));
            packsDt.Columns.Add("StateStatus", typeof(string));
            packsDt.Columns.Add("MarketDefinitionId", typeof(int));
            packsDt.Columns.Add("Alignment", typeof(string));
            packsDt.Columns.Add("Product", typeof(string));
            packsDt.Columns.Add("ChangeFlag", typeof(string));
            packsDt.Columns.Add("Molecule", typeof(string));

            foreach (var item in client[0].MarketDefinitions[0].MarketDefinitionPacks)
            {
                //packsDt.Rows.Add(item.Pack, item.MarketBase, item.MarketBaseId, item.GroupNumber, item.GroupName, item.Factor, item.PFC, item.Manufacturer, item.ATC4, item.NEC4, item.DataRefreshType, item.StateStatus, item.MarketDefinitionId, item.Alignment, item.Product, item.ChangeFlag, item.Molecule);
                packsDt.Rows.Add(item.Pack, item.MarketBase, item.MarketBaseId, item.GroupNumber, item.GroupName, item.Factor, item.PFC, item.Manufacturer, item.ATC4, item.NEC4, item.DataRefreshType, item.StateStatus, item.MarketDefinitionId, item.Alignment, item.Product, item.ChangeFlag, item.Molecule);
            }

            SqlParameter paramMarketDefinitionID = new SqlParameter("@marketdefinitionid", MarketDefId);

            SqlParameter paramPacks = new SqlParameter();
            paramPacks.ParameterName = "@TVP";
            paramPacks.SqlDbType = System.Data.SqlDbType.Structured;
            paramPacks.Value = packsDt;
            paramPacks.TypeName = "TYP_MarketDefinitionPacks";
            //_db.Database.ExecuteSqlCommand("exec  EditMarketDefinition @marketdefinitionid,@TVP", paramMarketDefinitionID, paramPacks);
            await _db.Database.ExecuteSqlCommandAsync("exec  EditMarketDefinition @marketdefinitionid,@TVP", paramMarketDefinitionID, paramPacks);
            
            /*var json = JsonConvert.SerializeObject(client[0].MarketDefinitions[0], Formatting.Indented,
                       new JsonSerializerSettings
                       {
                           ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                       });*/

            return Request.CreateResponse(HttpStatusCode.OK, client[0].MarketDefinitions[0]);

        }

        [Route("api/deleteClientMarketDef")]
        [HttpPost]       
        public HttpResponseMessage deleteClientMarketDef(int ClientId, int MarketDefId)
        {
            var UserId = Convert.ToInt32(((ClaimsIdentity)User.Identity).Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            try
            {
                AuthController objAuth = new AuthController();
                if (objAuth.CheckUserClients(ClientId) == 0)
                    return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to delete this market");

                var entity = _db.MarketDefinitions.FirstOrDefault(m => m.Id == MarketDefId);
                if (entity == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "This market is not available, Please try another.");
                }
                else
                {
                    //to clean Market definitionbase map
                    SqlParameter paramMarketID = new SqlParameter("@MarketDefID", MarketDefId);
                    SqlParameter paramUserId = new SqlParameter("@userId", UserId);
                    // _db.Database.ExecuteSqlCommand("exec DeleteMarketDefinition @MarketDefID", paramMarketID);
                    _db.Database.ExecuteSqlCommand("exec DeleteMarketDefinition_WithAudit @MarketDefID,@userId", paramMarketID, paramUserId);
                    return Request.CreateResponse(HttpStatusCode.OK, "Market has deleted successfully.");
                }

            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }

        [Route("api/checkSubcribedMarketDef")]
        [HttpPost]
        public string checkSubcribedMarketDef(int ClientId, int MarketDefId)
        {
            List<string> deliverableName = new List<string>();
            var subcribedMarketList = _db.DeliveryMarkets.Where(p => p.MarketDefId == MarketDefId).ToList();
            List<DeliveryMarket> lstDeleteDelMkt = new List<DeliveryMarket>();
            //loop through delivery market
            foreach (var objDel in subcribedMarketList)
            {
                deliverableName.Add(getSubscriptionName(objDel.deliverables));
            }

            var json = JsonConvert.SerializeObject(deliverableName, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });

            return json;
        }

        [Route("api/getDefinitionLockHistories")]
        [HttpGet]
        public string getDefinitionLockHistories(int UserId, int DefId, string DocType, string LockType, string Status)
        {
            List<LockHistory> lockHistory = new List<LockHistory>();

            lockHistory = _db.Database.SqlQuery<LockHistory>("Select LH.Id as Id, LH.DocType as DocType,LH.DefId as DefId,LH.ReleaseTime as ReleaseTime, LH.LockType as LockType,LH.UserId as UserId, LH.LockTime as LockTime,[User].FirstName+' ' +[User].LastName as Status from [LockHistories] LH,[User] Where LH.DefId='" + DefId + "' and LH.DocType='" + DocType + "' and LH.LockType='" + LockType + "' and LH.Status='Active' and LH.UserId=[User].UserID").ToList();

            var json = JsonConvert.SerializeObject(lockHistory, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });


            return json;
        }

        [Route("api/LockHistories")]
        [HttpGet]
        public string LockHistories(int UserId, int DefId, string DocType, string LockType, string Status)
        {
            List<LockHistory> lockHistory = new List<LockHistory>();
            DateTime currentDatetime = DateTime.Now;
            lockHistory = _db.Database.SqlQuery<LockHistory>("Select *,'' as UserName from LockHistories Where DefId='" + DefId + "' and UserId='" + UserId + "' and DocType='" + DocType + "' and LockType='" + LockType + "' and Status='Active'").ToList();
            //lockHistory.Add(new LockHistory { Id = 1, UserId= UserId, DefId= DefId,DocType= DocType, LockType= LockType,Status= "Active", LockTime= DateTime.Now});
            if (lockHistory.Count() > 0)
            {
                _db.Database.ExecuteSqlCommand("Update LockHistories set LockTime='" + currentDatetime + "' Where DefId='" + DefId + "' and UserId='" + UserId + "' and DocType='" + DocType + "' and Status='Active'");
            }
            else
            {
                _db.LockHistories.Add(new LockHistory { Id = 1, UserId = UserId, DefId = DefId, DocType = DocType, LockType = LockType, Status = "Active", LockTime = currentDatetime, ReleaseTime = null });
                _db.SaveChanges();

            }
            var json = JsonConvert.SerializeObject(lockHistory, Formatting.Indented,
                      new JsonSerializerSettings
                      {
                          ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                      });

            return json;
        }

        [Route("api/updateMarketDefName")]
        [HttpGet]
        public Boolean updateMarketDefName(int ClientId, int MarketDefId, string MarketDefName)
        {
            var data = _db.Database.ExecuteSqlCommand("Update MarketDefinitions set Name='" + MarketDefName + "' Where Id=" + MarketDefId + "");

            if (data == 1) { return true; }
            else { return false; }
        }

        [Route("api/SubmitMarketDef")]
        [HttpPost]
        public HttpResponseMessage SubmitMarketDef(int[] MarketDefIds, int userId)
        {
            foreach (int MarketDefId in MarketDefIds) {
                var data = _db.Database.ExecuteSqlCommand("exec [AuditSubmitMarketDefinition] " + MarketDefId + "," + userId);
            }
           

            return Request.CreateResponse(HttpStatusCode.OK);
        }

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
