using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models.Territory;
using System.Data.Entity.ModelConfiguration;
using System.Data.SqlClient;
using System.Web.Http.Cors;
using Newtonsoft.Json;
using System.Configuration;
using System.Data.Entity.Migrations;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Territory;
using System.Threading.Tasks;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Audit;
using System.Security.Claims;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class TerritoriesController : ApiController
    {
        private EverestPortalContext db = new EverestPortalContext();
        string ConnectionString = "EverestPortalConnection";
        private const string GROUPS_TREE_DELETE = @"with RowsToDelete as (
	        select ID
	        from dbo.Groups
	        where ID = @RootId
	
        	union all
	
	        select ch.ID
	        from dbo.Groups ch inner join RowsToDelete p
		    on p.ID = ch.Parent_Id
            )
            delete from dbo.Groups
            from dbo.Groups h inner join RowsToDelete d on h.ID = d.ID";

        private const string LEVELS_TREE_DELETE = @"with RowsToDelete as (
	        select ID
	        from dbo.Levels
	        where ID = @RootId
	
        	union all
	
	        select ch.ID
	        from dbo.Levels ch inner join RowsToDelete p
		    on p.ID = ch.Parent_Id
            )
            delete from dbo.Levels
            from dbo.Levels h inner join RowsToDelete d on h.ID = d.ID";

        private string REMAINING_OUTLETS = @"select top 10 ROW_NUMBER() OVER( ORDER BY A.OutletId) as NID, cast(OutletId as smallint) OutletId, OutletName, Address from
                                                  (select cast(Outlet as nvarchar) OutletId, OutletName, rtrim(ltrim(Address)) Address from tblOutlet 
                                                    except
                                                  select BrickOutletCode, BrickOutletName, rtrim(ltrim(Address)) Address from OutletBrickAllocations
                                                    where TerritoryId = @TerritoryId and Type = 'outlet')A";

        private string REMAINING_BRICKS = @"select Brick as BrickId, BrickName, ISNULL(Address, '') Address from vwBrick 
                                                    except
                                                  select BrickOutletCode, BrickOutletName, ISNULL(Address, '') Address from OutletBrickAllocations
                                                    where TerritoryId = @TerritoryId and Type = 'brick'";



        [Route("api/Territories")]
        [HttpGet]
        public string GetClientTerritories(int clientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return "";
            var objClient = db.Territories.Where(u => u.Client_Id == clientId).ToList<Territory>();
            var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

        [Route("api/ClientTerritories")]
        [HttpGet]
        public HttpResponseMessage GetClientTerritoriesV2(int clientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view territory definitions.");

            var objClient = db.Database.SqlQuery<Territory>("Select * from dbo.vwTerritories where Client_Id=" + clientId + " order by name").ToList();
            /* var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                         new JsonSerializerSettings
                         {
                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                         });*/

            return Request.CreateResponse(HttpStatusCode.OK, objClient);
        }


        [Route("api/GetTerritoryByClient")]
        [HttpGet]
        public HttpResponseMessage GetTerritoryByClient(int clientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to view market definitions.");
            List<TerritoryDTO> lstTerritoryDTO = GetTerritoryByClientData(clientId);
            return Request.CreateResponse(HttpStatusCode.OK, lstTerritoryDTO);
        }

        public List<TerritoryDTO> GetTerritoryByClientData(int clientId)
        {
            var territory = (from mar in db.Territories
                             where mar.Client_Id == clientId
                             orderby mar.Name
                             select mar).ToList();
            var territoryHistory = (from sub in db.Territories_History
                                    where sub.Client_Id == clientId
                                    group sub by sub.TerritoryId into tempGrp
                                    let maxVersion = tempGrp.Max(x => x.Version)
                                    select new
                                    {
                                        TerritoryId = tempGrp.Key,
                                        LastSaved = tempGrp.FirstOrDefault(y => y.Version == maxVersion).LastSaved,
                                        MaxVer = maxVersion
                                    }).ToList();

            TerritoryDTO objDTO;
            List<TerritoryDTO> lstTerritoryDTO = new List<TerritoryDTO>();
            foreach (Territory terr in territory)
            {
                objDTO = new TerritoryDTO();
                terr.CopyProperties(objDTO);
                objDTO.Id = terr.Id;
                if (!string.IsNullOrEmpty(terr.SRA_Client))
                    objDTO.Name = terr.Name + " (" + terr.SRA_Client + " " + terr.SRA_Suffix + ")";
                var res = territoryHistory.FirstOrDefault(i => i.TerritoryId == terr.Id);
                objDTO.Submitted = (res == null || res.LastSaved != terr.LastSaved) ? "No" : "Yes";
                lstTerritoryDTO.Add(objDTO);
            }
            List<TerritoryDTO> notSubmitted = lstTerritoryDTO.Where(t => t.Submitted == "No").ToList();
            notSubmitted.Sort(CompareByName);
            List<TerritoryDTO> submitted = lstTerritoryDTO.Where(t => t.Submitted == "Yes").ToList();
            submitted.Sort(CompareByName);
            List<TerritoryDTO> finalList = new List<TerritoryDTO>();
            finalList.AddRange(notSubmitted); finalList.AddRange(submitted);

            return finalList;
        }

        private int CompareByName(TerritoryDTO territory1, TerritoryDTO territory2)
        {            
            return string.Compare(territory1.Name, territory2.Name);
        }


        [Route("api/postTerritory")]
        [HttpPost]
        public async Task<HttpResponseMessage> postTerritory(int ClientId)
        {
            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            var territory = JsonConvert.DeserializeObject<Territory>(jsonContent); //DefaultValueHandling.Ignore
            Guid Id = Guid.NewGuid();
            int TerritoryID;
            var OutletBrickAllocations = territory.OutletBrickAllocation;//store in locally
            territory.OutletBrickAllocation = null;

            territory.GuiId = Id.ToString();

            bool isIMSStandard = false;
            //If TxRs created as IMS Structure then create records only in Territory table and use internal client TxRs for all the manipulation
            if (checkIsIMSStandardStructure(territory.Name))
            {
                territory.Levels = null;
                territory.RootGroup = null;
                territory.OutletBrickAllocation = null;
                isIMSStandard = true;
            }

            territory.LastModified = DateTime.Now;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            territory.ModifiedBy = uid;

            using (var db = new EverestPortalContext())
            {
                db.Territories.Add(territory);
                await db.SaveChangesAsync();
                TerritoryID = territory.Id;
            }

            List<Territory> objClient = new List<Territory>();
            if (!isIMSStandard)
            {
                await editTerritoryOutletBrickAllocation(TerritoryID, OutletBrickAllocations);
                objClient = db.Territories.Where(u => u.Client_Id == ClientId && u.GuiId == Id.ToString()).ToList<Territory>();
            }
            else
            {
                var internalClient = db.Clients.FirstOrDefault(c => c.Name.ToLower() == "internal");
                if (internalClient != null)
                {
                    objClient = db.Territories.Where(u => u.Client_Id == internalClient.Id && u.Name.ToLower() == territory.Name.ToLower()).ToList<Territory>();
                }
            }
            /*var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });*/

            return Request.CreateResponse(HttpStatusCode.OK, objClient);
        }
        [Route("api/copyTerritory")]
        [HttpPost]
        public async Task<HttpResponseMessage> copyTerritory(int DestClientId, int SourceTerritoryID, string DestTerritoryName, string Type)
        {
            var objClient = new List<Territory>();
            Guid Id = Guid.NewGuid();
            // get data
            if (Type == "IMS Standard Structure")
            {
                var internalClientID = db.Clients.Where(c => c.Name.ToLower() == "internal").Select(c => c.Id).FirstOrDefault();
                if (internalClientID != 0)
                {
                    objClient = db.Territories.Where(u => u.Name == DestTerritoryName && u.Client_Id == internalClientID).ToList<Territory>();
                }
            }
            else
            {
                objClient = db.Territories.Where(u => u.Client_Id == DestClientId && u.Id == SourceTerritoryID).ToList<Territory>();
            }

            //post data
            using (var db = new EverestPortalContext())
            {
                if (objClient.Count > 0)
                {
                    //to post structured territory
                    objClient[0].Client_Id = DestClientId;
                    objClient[0].Name = DestTerritoryName;
                    objClient[0].GuiId = Id.ToString();
                    objClient[0].IsUsed = true;

                    //Json format to avoid link
                    var jsonData = JsonConvert.SerializeObject(objClient[0], Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            });
                    var territoryData = JsonConvert.DeserializeObject<Territory>(jsonData);
                    territoryData.LastModified = DateTime.Now;
                    var identity = (ClaimsIdentity)User.Identity;
                    int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
                    territoryData.ModifiedBy = uid;

                    //If TxRs created as IMS Structure then create records only in Territory table and use internal client TxRs for all the manipulation
                    if (Type == "IMS Standard Structure")
                    {
                        territoryData.Levels = null;
                        territoryData.RootGroup = null;
                        territoryData.OutletBrickAllocation = null;
                    
                        db.Territories.Add(territoryData);
                        db.SaveChanges();
                    }
                    else
                    {
                        var OutletBrickAllocation = territoryData.OutletBrickAllocation;
                        territoryData.OutletBrickAllocation = null;
                        db.Territories.Add(territoryData);
                        db.SaveChanges();
                        var newTerritoryID = territoryData.Id;
                        await editTerritoryOutletBrickAllocation(newTerritoryID, OutletBrickAllocation);
                    }
                }
            }

            var getTerritoryDetails = new List<Territory>();
            if (Type == "IMS Standard Structure")
            {
                var internalClientID = db.Clients.Where(c => c.Name.ToLower() == "internal").Select(c => c.Id).FirstOrDefault();
                if (internalClientID != 0)
                {
                    getTerritoryDetails = db.Territories.Where(u => u.Name == DestTerritoryName && u.Client_Id == internalClientID).ToList<Territory>();
                }
            }
            else
            {
                getTerritoryDetails = db.Territories.Where(u => u.Client_Id == DestClientId && u.GuiId == Id.ToString()).ToList<Territory>();
            }
                
            return Request.CreateResponse(HttpStatusCode.OK, getTerritoryDetails);

        }

        [Route("api/editTerritory")]
        [HttpPost]
        public async Task<HttpResponseMessage> editTerritory(int ClientId, int TerritoryId)
        {

            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit this territory definition.");

            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;
            var territory = JsonConvert.DeserializeObject<Territory>(jsonContent);
            var OutletBrickAllocations = territory.OutletBrickAllocation;//stored allocated bricks outlets
                                                                         //assign Old territory ID            
            var rootGroups = assignTerritoryIdInGroups(territory.RootGroup, TerritoryId);

            //assign Old territory ID
            for (var i = 0; i < territory.Levels.Count(); i++)
            {
                territory.Levels[i].TerritoryId = TerritoryId;

            }
            var levels = territory.Levels;

            //assign null vaules
            territory.RootGroup = null;
            territory.Levels = null;
            territory.OutletBrickAllocation = null;
            territory.LastSaved = DateTime.Now;
            territory.LastModified = DateTime.Now;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            territory.ModifiedBy = uid;

            //to delete old info
            // to delete old groups and link to new group with territory table
            SqlParameter pTerritoryId = new SqlParameter("@pTerritoryId", TerritoryId);
            //db.Database.ExecuteSqlCommand("exec IRPDeleteGroupsLevelsBricks @pTerritoryId", pTerritoryId);
            await db.Database.ExecuteSqlCommandAsync("exec IRPDeleteGroupsLevelsBricks @pTerritoryId", pTerritoryId);

            string oldTerritoryName = string.Empty;
            if (checkIsInternalClient(ClientId))
            {
                oldTerritoryName = db.Territories.AsNoTracking<Territory>().Where(t => t.Id == territory.Id).Select(t => t.Name).FirstOrDefault();
            }

            using (var db = new EverestPortalContext())
            {
                db.Territories.AddOrUpdate(territory);
                db.Levels.AddRange(levels);
                //db.OutletBrickAllocations.AddRange(outletBrickAllocation);
                db.Groups.Add(rootGroups);
                //db.SaveChanges();
                await db.SaveChangesAsync();
            }

            // to and link to new group with territory table
            //db.Database.ExecuteSqlCommand("Update territories set RootGroup_id=(Select Id from Groups Where TerritoryId=" + TerritoryId + " and Name='Australia' and id<=(Id)) Where Id=" + TerritoryId + "");
            await db.Database.ExecuteSqlCommandAsync("Update territories set RootGroup_id=(Select Id from Groups Where TerritoryId=" + TerritoryId + " AND GroupNumber=11 and id<=(Id)) Where Id=" + TerritoryId + "");


            await editTerritoryOutletBrickAllocation(TerritoryId, OutletBrickAllocations);

            if (!string.IsNullOrEmpty(oldTerritoryName))
            {
                UpdateAllIMSStandard(oldTerritoryName, territory);
            }

            var objClient = db.Territories.Where(u => u.Id == TerritoryId).ToList<Territory>();

            /*var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });*/

            // add unassigned brick/outlets to new group 
            UpdateUnAssignedGroupsTerritories(TerritoryId);

            return Request.CreateResponse(HttpStatusCode.OK, objClient);

        }


        [Route("api/createUnassignedGroup")]
        [HttpPost]
        public async Task<HttpResponseMessage> createUnAssignedGroupTerritory(int ClientId, int TerritoryId)
        {
            SqlParameter pTerritoryId = new SqlParameter("@territoryid", TerritoryId);
            //db.Database.ExecuteSqlCommand("exec IRPDeleteGroupsLevelsBricks @pTerritoryId", pTerritoryId);
            await db.Database.ExecuteSqlCommandAsync("exec CreateUnassignedGroup @territoryid", pTerritoryId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        private  void UpdateUnAssignedGroupsTerritories(int TerritoryId)
        {
            try
            {
                SqlParameter pTerritoryId = new SqlParameter("@territoryid", TerritoryId);
                //db.Database.ExecuteSqlCommand("exec IRPDeleteGroupsLevelsBricks @pTerritoryId", pTerritoryId);
                db.Database.ExecuteSqlCommand("exec CreateUnassignedGroup @territoryid", pTerritoryId);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

           

        [Route("api/deleteTerritory")]
        [HttpPost]
        public HttpResponseMessage deleteTerritory(int ClientId, int TerritoryId)
        {
            var UserId = Convert.ToInt32(((ClaimsIdentity)User.Identity).Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
           
            SqlParameter paramTerritoryId = new SqlParameter("@TerritoryId", TerritoryId);
            SqlParameter paramUserId = new SqlParameter("@userId", UserId);
            db.Database.ExecuteSqlCommand("exec IRPDeleteTerritory_WithAudit @TerritoryId,@userId", paramTerritoryId, paramUserId);

            //using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            //{
            //    conn.Open();
            //    using (SqlCommand cmd = new SqlCommand("IRPDeleteTerritory", conn))
            //    {
            //        cmd.Parameters.Add(new SqlParameter("@pTerritoryId", SqlDbType.Int)).Value = TerritoryId;
            //        cmd.CommandType = CommandType.StoredProcedure;
            //        cmd.ExecuteNonQuery();
            //    }
            //    conn.Close();
            //}
            return Request.CreateResponse(HttpStatusCode.OK, "Territory has deleted successfully.");
        }

        [Route("api/getTerritory")]
        [HttpGet]
        public HttpResponseMessage GetClientTerritories(int clientId, int TerritoryId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");

            var objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Id == TerritoryId).ToList<Territory>();
            return Request.CreateResponse(HttpStatusCode.OK, objClient);
        }
        [Route("api/getTerritory")]
        [HttpGet]
        public HttpResponseMessage ClientTerritories(int clientId, int TerritoryId, string TerritoryName)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0 && clientId != 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");

            var objClient = new List<Territory>();
            string currentTerritoryName = string.Empty;
            if (TerritoryName == null)
                currentTerritoryName = db.Territories.Where(t => t.Client_Id == clientId && t.Id == TerritoryId).Select(x => x.Name).FirstOrDefault();
            else
                currentTerritoryName = TerritoryName;

            if (!string.IsNullOrEmpty(currentTerritoryName) && checkIsIMSStandardStructure(currentTerritoryName))
            {
                if (!checkIsInternalClient(clientId))
                {
                    var isInternalClient = db.Clients.FirstOrDefault(c => c.Name.ToLower() == "internal");
                    objClient = new List<Territory>();
                    objClient = db.Territories.Where(u => u.Client_Id == isInternalClient.Id && u.Name.ToLower() == currentTerritoryName).ToList<Territory>();
                }
                else
                {
                    if (TerritoryName == null)
                        objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Id == TerritoryId).ToList<Territory>();
                    else
                        objClient = db.Territories.Where(u => u.Name == TerritoryName && u.Client_Id == clientId).ToList<Territory>();
                }
            }
            else
            {
                if (TerritoryName == null)
                    objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Id == TerritoryId).ToList<Territory>();
                else
                    objClient = db.Territories.Where(u => u.Name == TerritoryName && u.Client_Id == clientId).ToList<Territory>();
            }

            if (objClient.Count == 0) {
                return Request.CreateResponse(HttpStatusCode.NotFound, "This territory is not available, please try another.");
            }
            else
            {
                foreach (var ter in objClient)
                {
                    var childrens = ter.RootGroup.Children;
                    childrens = childrens.Where(c => !c.Name.Equals("unassigned",StringComparison.InvariantCultureIgnoreCase)).ToList();
                    ter.RootGroup.Children = childrens;
                }
            }

            


            return Request.CreateResponse(HttpStatusCode.OK, objClient);
        }

        [Route("api/getTerritory")]
        [HttpGet]
        public HttpResponseMessage ClientTerritories(string clientName, int TerritoryId, string TerritoryName)
        {
            AuthController objAuth = new AuthController();
            var client = db.Clients.FirstOrDefault(x => x.Name.ToLower() == clientName);

            if (objAuth.CheckUserClients(client.Id) == 0 && client.Id != 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");
            var objClient = new List<Territory>();
            if (TerritoryName == null)
                objClient = db.Territories.Where(u => u.Client_Id == client.Id && u.Id == TerritoryId).ToList<Territory>();
            else
                objClient = db.Territories.Where(u => u.Name == TerritoryName && u.Client_Id == client.Id).ToList<Territory>();

            if (objClient.Count == 0)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, "This territory is not available, please try another.");
            }

            return Request.CreateResponse(HttpStatusCode.OK, objClient);
        }

        /*
          public string GetClientTerritories(int clientId, int TerritoryId, string TerritoryName)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return "";
            var objClient = new List<Territory>();
            if (TerritoryName == null)
                objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Id == TerritoryId).ToList<Territory>();
            else
                objClient = db.Territories.Where(u => u.Name == TerritoryName && u.Client_Id == clientId).ToList<Territory>();
            var json = JsonConvert.SerializeObject(objClient, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }*/

        [Route("api/updateTerritoryBaseInfo")]
        [HttpPost]
        public HttpResponseMessage updateTerritoryBaseInfo(int ClientId, int TerritoryId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definitions.");

            HttpContent requestContent = Request.Content;
            var jsonContent = requestContent.ReadAsStringAsync().Result;

            var territory = JsonConvert.DeserializeObject<Territory>(jsonContent);

            //assign null vaules
            territory.RootGroup = null;
            territory.Levels = null;
            territory.OutletBrickAllocation = null;
            territory.LastSaved = DateTime.Now;

            string oldTerritoryName = string.Empty;
            if (checkIsInternalClient(ClientId))
            {
                oldTerritoryName = db.Territories.AsNoTracking<Territory>().Where(t => t.Id == territory.Id).Select(t => t.Name).FirstOrDefault();
            }

            territory.LastModified = DateTime.Now;
            var identity = (ClaimsIdentity)User.Identity;
            int uid = Convert.ToInt32(identity.Claims.FirstOrDefault(c => c.Type == "userid").Value.ToString());
            territory.ModifiedBy = uid;

            using (var db = new EverestPortalContext())
            {
                db.Territories.AddOrUpdate(territory);
                db.SaveChanges();
            }

            if (!string.IsNullOrEmpty(oldTerritoryName))
            {
                UpdateAllIMSStandard(oldTerritoryName, territory);
            }

            return Request.CreateResponse(HttpStatusCode.OK, "Territory has updated successfully.");
        }
        [Route("api/checkIMSHierarchy")]
        [HttpGet]
        public HttpResponseMessage CheckIMSHierarchy(int clientId, int TerritoryId, string TerritoryName)
        {
            var objClient = new List<Territory>();
            if (TerritoryName == null)
                objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Id == TerritoryId).ToList<Territory>();
            else
                objClient = db.Territories.Where(u => u.Client_Id == clientId && u.Name == TerritoryName).ToList<Territory>();

            if (objClient.Count() == 0)
                return Request.CreateResponse(HttpStatusCode.OK, false);
            else return Request.CreateResponse(HttpStatusCode.OK, true);
        }

        [Route("api/checkForTerritoryDefDuplication")]
        [HttpGet]
        public HttpResponseMessage checkForTerritoryDefDuplication(int ClientId, string TerritoryName)
        {
            var data = db.Territories.Where(u => u.Name.Equals(TerritoryName, StringComparison.CurrentCultureIgnoreCase) && u.Client_Id == ClientId).FirstOrDefault();

            if (data != null)
            {
                return Request.CreateResponse(HttpStatusCode.OK, false);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.OK, true);
            }
        }

        [Route("api/checkForTerritoryDefDuplication")]
        [HttpGet]
        public HttpResponseMessage checkForTerritoryDefDuplication(int ClientId, int TerritoryId, string TerritoryName)
        {
            var data = db.Territories.Where(u => u.Name.Equals(TerritoryName, StringComparison.CurrentCultureIgnoreCase) && u.Client_Id == ClientId && u.Id != TerritoryId).FirstOrDefault();

            if (data != null)
            {
                return Request.CreateResponse(HttpStatusCode.OK, false);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.OK, true);
            }
        }

        [Route("api/checkSRADuplication")]
        [HttpGet]
        public HttpResponseMessage checkSRADuplication(int ClientId, int TerritoryId, string SRAClient, string SRASuffix, string LD, string AD)
        {
            List<Territory> data = new List<Territory>();
            List<Territory> LDList = new List<Territory>();
            List<Territory> ADList = new List<Territory>();
            List<Territory> validationDetails = new List<Territory>();

            char SRANewSuffix = 'A';
            var suffixOverflow = false;
            if (TerritoryId > 0)
            {
                bool isIMSStandardForNonInternalClient = false;
                if (!checkIsInternalClient(ClientId))
                {
                    string territoryName = db.Territories.Where(t => t.Id == TerritoryId).Select(t => t.Name).FirstOrDefault();
                    if (!string.IsNullOrEmpty(territoryName))
                        isIMSStandardForNonInternalClient = checkIsIMSStandardStructure(territoryName);
                }

                if (!isIMSStandardForNonInternalClient)
                {
                    data = db.Territories.Where(u => u.Id != TerritoryId && u.Client_Id == ClientId && u.SRA_Client == SRAClient.ToString() && u.SRA_Suffix == SRASuffix.ToString()).ToList();
                    LDList = db.Territories.Where(u => u.Id != TerritoryId && u.Client_Id == ClientId && u.LD == LD.ToString()).ToList();
                    ADList = db.Territories.Where(u => u.Id != TerritoryId && u.Client_Id == ClientId && u.AD == AD.ToString()).ToList();
                }
                
            }
            else
            {
                data = db.Territories.Where(u => u.Client_Id == ClientId && u.SRA_Client == SRAClient.ToString() && u.SRA_Suffix == SRASuffix.ToString()).ToList();
                LDList = db.Territories.Where(u => u.Client_Id == ClientId && u.LD == LD.ToString()).ToList();
                ADList = db.Territories.Where(u => u.Client_Id == ClientId && u.AD == AD.ToString()).ToList();
            }

            //to check suffix overflow
            if (data.Count() > 0)
            {
                var territoryList = db.Territories.Where(p => p.Client_Id == ClientId && p.SRA_Client == SRAClient.ToString()).OrderBy(o => o.SRA_Suffix);
                //loop through to make SRASuffix 
                foreach (var objTerritory in territoryList)
                {
                    if (objTerritory.SRA_Suffix == SRANewSuffix.ToString())
                    {
                        if (objTerritory.SRA_Suffix == 'Z'.ToString())
                        {
                            suffixOverflow = true;
                        }
                        else
                        {
                            SRANewSuffix = Convert.ToChar((SRANewSuffix) + 1);
                        }
                    }
                }
            }


            validationDetails.Add(new Territory { SRA_Client = data.Count() > 0 ? "true" : "false", LD = LDList.Count() > 0 ? "true" : "false", AD = ADList.Count() > 0 ? "true" : "false", IsUsed = suffixOverflow });
            return Request.CreateResponse(HttpStatusCode.OK, validationDetails);
        }

        [Route("api/getBrickOutlet")]
        [HttpGet]
        public HttpResponseMessage GetBrickOutlet(string Type, string Role, int ClientID)
        {
            var result = new DataTable();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientID) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");

            if (Type.ToLower().Contains("brick"))
            {
                //var objects = db.vwBrick.ToList<Brick>();
                //foreach (var item in objects)
                //{
                //    var newBrick = new OutletBrick() { Code = item.BrickId.ToString(), Name = item.BrickName, Type = Type };
                //    bricks.Add(newBrick);
                //}

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("[dbo].[GetAllBricks]", conn))
                    {
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            da.Fill(result);
                        }
                    }
                }
            }
            else
            {
                //var objects = db.vwOutlet.ToList<Outlet>();
                //foreach (var item in objects)
                //{
                //    var newOutlet = new OutletBrick() { Code = item.OutletId.ToString(), Name = item.OutletName, Address = item.Address, Type = Type };
                //    results.Add(newOutlet);
                //}
                int roleStatus = (Role.ToLower().Contains("manager") || Role.ToLower().Contains("analyst")) ? 0 : 1;
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("[dbo].[GetAllOutlets]", conn))
                    {
                        cmd.Parameters.Add(new SqlParameter("@Role", SqlDbType.Int));
                        cmd.Parameters["@Role"].Value = roleStatus;
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            da.Fill(result);
                        }
                    }
                }
            }

            /*var json = JsonConvert.SerializeObject(result, Formatting.Indented,
            new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            });*/

            return Request.CreateResponse(HttpStatusCode.OK, result);

        }

        [Route("api/getBrickOutletAllocationCount")]
        [HttpGet]
        public string GetBrickOutletAllocationCount(int clientId, int TerritoryId, string Type)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return "";
            var query = (from n in db.OutletBrickAllocations
                         where (n.TerritoryId == TerritoryId && n.Type == Type)
                         group n by new { n.NodeCode, n.NodeName, n.LevelName, n.CustomGroupNumberSpace, n.BannerGroup, n.State, n.Panel, n.BrickOutletLocation }

                         into grp
                         select new
                         {
                             grp.Key.NodeCode,
                             grp.Key.NodeName,
                             grp.Key.LevelName,
                             grp.Key.CustomGroupNumberSpace,
                             grp.Key.BannerGroup,
                             grp.Key.State,
                             grp.Key.Panel,
                             grp.Key.BrickOutletLocation,
                             BrickOutletCount = grp.Count(),
                         }).ToList();
            return "ok";
        }

        [Route("api/getBrickOutletUpdated")]
        [HttpGet]
        public HttpResponseMessage GetBrickOutletUpdated(string type, int territoryId, string Role, int clientId)
        {

            DataTable results = new DataTable();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");

            if (type.ToLower().Contains("brick"))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("[dbo].[GetUpdatedBricks]", conn))
                    {
                        cmd.Parameters.Add(new SqlParameter("@TerritoryId", SqlDbType.NVarChar));
                        cmd.Parameters["@TerritoryId"].Value = territoryId;

                        using (var da = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            da.Fill(results);
                        }

                    }
                }
            }
            else
            {
                //REMAINING_OUTLETS = REMAINING_OUTLETS.Replace("@TerritoryId", territoryId.ToString());
                //var remainingOutlets = db.vwOutlet.SqlQuery(REMAINING_OUTLETS).ToList();
                //foreach (var item in remainingOutlets.Distinct())
                //{
                //    var newOutlet = new OutletBrick() { Code = item.OutletId.ToString(), Name = item.OutletName, Address = item.Address, Type = type };
                //    results.Add(newOutlet);
                //}

                int roleStatus = (Role.ToLower().Contains("manager") || Role.ToLower().Contains("analyst")) ? 0 : 1;
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["EverestPortalConnection"].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("[dbo].[GetUpdatedOutlets]", conn))
                    {
                        cmd.Parameters.Add(new SqlParameter("@TerritoryId", SqlDbType.NVarChar));
                        cmd.Parameters["@TerritoryId"].Value = territoryId;
                        cmd.Parameters.Add(new SqlParameter("@Role", SqlDbType.Int));
                        cmd.Parameters["@Role"].Value = roleStatus;

                        using (var da = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            da.Fill(results);
                        }

                    }
                }
            }

            /*var json = JsonConvert.SerializeObject(results, Formatting.Indented,
            new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            });*/

            return Request.CreateResponse(HttpStatusCode.OK, results);

        }

        public class RequestTerritoryHistorySubmit
        {
            public List<int> TerritoryId { get; set; }
            public int UserId { get; set; }

        }
        [Route("api/SubmitTerritory")]
        [HttpPost]
        public HttpResponseMessage SubmitTerritory([FromBody]RequestTerritoryHistorySubmit request)
        {
            IAuditLog log = AuditFactory.GetInstance(typeof(Territory).Name);
            var UserId = request.UserId;
            var territory = request.TerritoryId;
            foreach (var tId in territory)
            {
                var objClient = db.Territories.Where(u => u.Id == tId).ToList().FirstOrDefault();
                log.SaveVersion<Territory>(objClient, UserId);
            }

                

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/checkSubcribedTerritoryDef")]
        [HttpPost]
        public HttpResponseMessage checkSubcribedTerritoryDef(int ClientId, int TerritoryID)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");
            List<string> deliverableName = new List<string>();
            var subcribedTerritoryList = db.DeliveryTerritories.Where(p => p.TerritoryId == TerritoryID).ToList();
            List<DeliveryMarket> lstDeleteDelMkt = new List<DeliveryMarket>();
            //loop through delivery market
            foreach (var objDel in subcribedTerritoryList)
            {
                deliverableName.Add(getSubscriptionName(objDel.deliverables));
            }

            return Request.CreateResponse(HttpStatusCode.OK, deliverableName);
        }
        [Route("api/populateSRAInfo")]
        [HttpPost]
        public HttpResponseMessage populateSRAInfo(int ClientId)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(ClientId) == 0)
                return Request.CreateResponse(HttpStatusCode.Unauthorized, "You have no permission to edit/view this territory definition.");

            List<Territory> NewSRAInfo = new List<Territory>();
            char SRASuffix = 'A';
            var SRAClientNo = "";
            var gereratedLD = 0;
            var gereratedAD = 0;
            Boolean suffixOverflow = false;
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionString].ConnectionString))
            {
                conn.Open();
                using (var command = conn.CreateCommand())
                {
                    command.CommandText = "SELECT top 1 IRPClientNo FROM IRP.ClientMap Where ClientId='" + ClientId + "' ";
                    object execution = command.ExecuteScalar();
                    if (execution != null)
                    {
                        SRAClientNo = execution.ToString();
                    }
                }
                conn.Close();
            }


            var clientTerritoryList = db.Territories.Where(p => p.Client_Id == ClientId).OrderBy(o => o.LD);
            var territoryList = clientTerritoryList.Where(p => p.SRA_Client == SRAClientNo).OrderBy(o => o.SRA_Suffix);
            var clientTerritoriesReorderAD = clientTerritoryList.Where(p => p.AD != null).OrderBy(o => o.AD);
            var clientTerritoriesReorderLD = clientTerritoryList.Where(p => p.LD != null).OrderBy(o => o.LD);

            //loop through to make SRASuffix 
            foreach (var objTerritory in territoryList)
            {
                if (objTerritory.SRA_Suffix == SRASuffix.ToString())
                {
                    if (objTerritory.SRA_Suffix.ToUpper() == 'Z'.ToString())
                    {
                        SRASuffix = 'A';
                        suffixOverflow = true;
                    }
                    else
                    {
                        SRASuffix = Convert.ToChar((SRASuffix) + 1);
                    }
                }
            }


            //loop to generate LD and AD 
            foreach (var objTerritory in clientTerritoriesReorderAD)
            {
                gereratedAD = Math.Max(gereratedAD, Int32.Parse(objTerritory.AD));
            }
            //generate LD
            foreach (var objTerritory in clientTerritoriesReorderLD)
            {
                gereratedLD = Math.Max(gereratedLD, Int32.Parse(objTerritory.LD));
            }


            NewSRAInfo.Add(new Territory { SRA_Client = SRAClientNo, SRA_Suffix = suffixOverflow == false ? SRASuffix.ToString() : "", LD = (gereratedLD + 1).ToString(), AD = (gereratedAD + 1).ToString(), IsUsed = suffixOverflow });
            return Request.CreateResponse(HttpStatusCode.OK, NewSRAInfo);
        }

        private string getSubscriptionName(Deliverables obj)
        {
            string deliveryName = string.Empty;
            deliveryName = obj.subscription.country.Name + " " + obj.subscription.service.Name + " " + obj.subscription.dataType.Name
                + " " + obj.subscription.source.Name + " ";

            deliveryName = deliveryName + obj.deliveryType.Name + " " + obj.frequencyType.Name;
            return deliveryName;
        }

        public Group assignTerritoryIdInGroups(Group group, int territoryId)
        {

            if (group.Children == null)
            {
                group.TerritoryId = territoryId;

            }
            else
            {
                group.TerritoryId = territoryId;
                for (var i = 0; i < group.Children.Count(); i++)
                {
                    assignTerritoryIdInGroups(group.Children[i], territoryId);
                }


            }
            return group;
        }



        public async Task editTerritoryOutletBrickAllocation(int TerritoryID, List<OutletBrickAllocation> OutletBrickAllocations)
        {
            var packsDt = new DataTable();
            packsDt.Columns.Add("NodeCode", typeof(string));
            packsDt.Columns.Add("NodeName", typeof(string));
            packsDt.Columns.Add("Address", typeof(string));
            packsDt.Columns.Add("BrickOutletCode", typeof(string));
            packsDt.Columns.Add("BrickOutletName", typeof(string));
            packsDt.Columns.Add("LevelName", typeof(string));
            packsDt.Columns.Add("CustomGroupNumberSpace", typeof(string));
            packsDt.Columns.Add("Type", typeof(string));
            packsDt.Columns.Add("BannerGroup", typeof(string));
            packsDt.Columns.Add("State", typeof(string));
            packsDt.Columns.Add("Panel", typeof(Char));
            packsDt.Columns.Add("BrickOutletLocation", typeof(string));
            packsDt.Columns.Add("TerritoryId", typeof(int));


            foreach (var item in OutletBrickAllocations)
            {
                item.TerritoryId = TerritoryID;
                packsDt.Rows.Add(item.NodeCode, item.NodeName, item.Address, item.BrickOutletCode, item.BrickOutletName, item.LevelName, item.CustomGroupNumberSpace, item.Type,
                    item.BannerGroup, item.State, item.Panel, item.BrickOutletLocation, item.TerritoryId);
            }

            SqlParameter territoryID = new SqlParameter("@territoryID", TerritoryID);
            SqlParameter paramOutletBricks = new SqlParameter("@TVP", packsDt);
            paramOutletBricks.SqlDbType = System.Data.SqlDbType.Structured;
            paramOutletBricks.TypeName = "TYP_OutletBrickAllocations";
            //db.Database.ExecuteSqlCommand("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);
            await db.Database.ExecuteSqlCommandAsync("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);

        }


        [Route("api/checkIsInternalClient")]
        [HttpGet]
        public bool checkIsInternalClient(int ClientId)
        {
            var isInternal = db.Clients.FirstOrDefault(c => c.Id == ClientId && c.Name.ToLower() == "internal");
            if (isInternal != null)
            {
                return true;
            }
            return false;
        }

        [Route("api/getAllTerritoriesName")]
        [HttpGet]
        public List<TerritoryOptionsDTO> getAllTerritoriesName(int clientId)
        {
            var territory = db.Database.SqlQuery<TerritoryOptionsDTO>("select t.Name, t.IsBrickBased from Territories t where t.Client_id=" + clientId).ToList();
            return territory;
        }


        [Route("api/getIMSStandardStructure")]
        [HttpGet]
        public List<TerritoryOptionsDTO> getIMSStandardStructure()
        {
            //var territory = db.Territories
            //    .Join(db.Clients, t => t.Client_Id, c => c.Id, (t, c) => new { t, c })
            //    .Where(x => x.c.Name.ToLower() == "internal" && x.t.IsReferenced == true)
            //    .Select(x => x.t).ToList();
            var territory = db.Database.SqlQuery<TerritoryOptionsDTO>("select t.Name, t.IsBrickBased from Territories t inner join Clients c on t.Client_id=c.Id where c.Name='internal' and t.IsReferenced=1").ToList();
            return territory;
        }

        private void UpdateAllIMSStandard(string oldTerritoryName, Territory territory)
        {
            string query = "update dbo.Territories set Name='" + territory.Name + "', IsBrickBased=" + (territory.IsBrickBased ? 1 : 0) + ", SRA_Client= '" + territory.SRA_Client + "', SRA_Suffix = '" + territory.SRA_Suffix + "', AD = '" + territory.AD + "', LD= '" + territory.LD + "' where Name = '" + oldTerritoryName + "'";
            db.Database.ExecuteSqlCommandAsync(query);
        }

        private bool checkIsIMSStandardStructure(string TerritoryName)
        {
            var territory = db.Territories
                .Join(db.Clients, t => t.Client_Id, c => c.Id, (t, c) => new { t, c })
                .Where(x => x.t.Name.ToLower() == TerritoryName.ToLower() && x.c.Name.ToLower() == "internal").ToList();

            if (territory.Count > 0)
            {
                return true;
            }

            return false;
        }
    }

    public class TerritoryOptionsDTO
    {
        public string Name { get; set; }
        public bool IsBrickBased { get; set; }
    }
}