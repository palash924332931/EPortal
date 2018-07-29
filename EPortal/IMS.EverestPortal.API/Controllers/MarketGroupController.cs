using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Grouping;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Migrations;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.EverestPortal.API.Controllers
{
    public class MarketGroupController : ApiController
    {
        private EverestPortalContext _db = new EverestPortalContext();
        
        [Route("api/GetMarketGroup")]
        [HttpGet]
        public HttpResponseMessage GetMarketGroup(int MarketDefinitionId)
        {
            var marketGroupView = _db.Database.SqlQuery<GroupView>("select * from [dbo].[vwGroupView] where marketdefinitionid=" + MarketDefinitionId).ToList();
            var marketGroupPack = _db.MarketGroupPacks.Where(p => p.MarketDefinitionId == MarketDefinitionId).ToList();
            var marketGroupFilter = _db.MarketGroupFilters.Where(f => f.MarketDefinitionId == MarketDefinitionId).ToList();
            
            var result = new
            {
                MarketGroupView = marketGroupView,
                MarketGroupPacks = marketGroupPack,
                MarketGroupFilter = marketGroupFilter
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [Route("api/postMarketGroup")]
        [HttpPost]
        public async Task<string> PostMarketGroup(MarketGroupDTO marketGroupDTO)
        {
            if (marketGroupDTO != null)
            {
                //await SaveGroupData(marketGroupDTO.MarketDefinitionId, marketGroupDTO.GroupView);
                //await SaveMarketGroupPack(marketGroupDTO.MarketDefinitionId, marketGroupDTO.MarketGroupPack);
            }
            return "";
        }

        [Route("api/SaveMarketGroupDetails")]
        [HttpPost]
        public async Task<HttpResponseMessage> SaveMarketGroupDetails(int MarketDefId, int ClientId)
        {
            HttpContent requestContent = Request.Content;
            string jsonContent = requestContent.ReadAsStringAsync().Result;
            var marketDefinitionDetails = JsonConvert.DeserializeObject<MarketDefinitionDetails>(jsonContent);
            MarketDefinition marketDefinition = marketDefinitionDetails.MarketDefinition;
            var IsEdit = MarketDefId > 0 ? 1 : 0;

            List<MarketDefinitionPack> marketDefinitionPacks = marketDefinition.MarketDefinitionPacks;//store Packs
            List<MarketDefinitionBaseMap> marketDefinitionBaseMaps = marketDefinition.MarketDefinitionBaseMaps;
            marketDefinition.MarketDefinitionPacks = null;
            marketDefinition.MarketDefinitionBaseMaps = null;
            //to delete previous market base
            //_db.Database.ExecuteSqlCommand("Delete from MarketDefinitionbaseMaps Where marketdefinitionid=" + MarketDefId);
            SqlParameter paramMarketID = new SqlParameter("@MarketDefID", MarketDefId);
            await _db.Database.ExecuteSqlCommandAsync("exec DeleteMarketDefinitionBaseMap @MarketDefID", paramMarketID);

            var mkt = new MarketDefinition() { Id = MarketDefId, Name = marketDefinition.Name, ClientId = ClientId, Client = null, MarketDefinitionBaseMaps = null, MarketDefinitionPacks = null, LastSaved= DateTime.Now };
            _db.MarketDefinitions.AddOrUpdate(mkt);
            _db.SaveChanges();
            MarketDefId = mkt.Id;

            // to update market definitionId in base maps
            foreach (MarketDefinitionBaseMap rec in marketDefinitionBaseMaps) {
                rec.MarketDefinitionId = MarketDefId;
            }           

            //to add marketbase again.
            _db.MarketDefinitionBaseMaps.AddRange(marketDefinitionBaseMaps);
            await _db.SaveChangesAsync();

            await SaveMarketPacks(marketDefinitionPacks, MarketDefId);
            await SaveGroupData(MarketDefId, marketDefinitionDetails.GroupView, IsEdit);
            await SaveMarketGroupPack(MarketDefId, marketDefinitionDetails.MarketGroupPack, IsEdit);
            if (marketDefinitionDetails.MarketGroupFilter != null)
                await SaveMarketGroupFilter(MarketDefId, marketDefinitionDetails.MarketGroupFilter, IsEdit);

            //return market info
            var returnDetails = new MarketDefinition() { Id = MarketDefId, Name = mkt.Name, ClientId = mkt.ClientId };
            return Request.CreateResponse(HttpStatusCode.OK, returnDetails);
        }


        public async Task SaveGroupData(int MarketDefinitionId, List<GroupView> GroupViewTable, int IsEdit)
        {
            var groupViewDt = new DataTable();
            groupViewDt.Columns.Add("Id", typeof(int));
            groupViewDt.Columns.Add("AttributeId", typeof(int));
            groupViewDt.Columns.Add("ParentId", typeof(int));
            groupViewDt.Columns.Add("GroupId", typeof(int));
            groupViewDt.Columns.Add("IsAttribute", typeof(bool));
            groupViewDt.Columns.Add("GroupName", typeof(string));
            groupViewDt.Columns.Add("AttributeName", typeof(string));
            groupViewDt.Columns.Add("OrderNo", typeof(int));
            groupViewDt.Columns.Add("MarketDefinitionId", typeof(int));
            groupViewDt.Columns.Add("GroupOrderNo", typeof(int));

            foreach (var item in GroupViewTable)
            {
                item.MarketDefinitionId = MarketDefinitionId;
                groupViewDt.Rows.Add(item.Id, item.AttributeId, item.ParentId, item.GroupId, item.IsAttribute, item.GroupName, item.AttributeName, item.OrderNo, item.MarketDefinitionId, item.GroupOrderNo);
            }

            SqlParameter MarketEditFlag = new SqlParameter("@isEdit", IsEdit);
            SqlParameter paramGroups = new SqlParameter("@groupView", groupViewDt);
            paramGroups.SqlDbType = System.Data.SqlDbType.Structured;
            paramGroups.TypeName = "typGroupView";
            SqlParameter paramMarketDefinitionId = new SqlParameter("@marketDefId", MarketDefinitionId);

            //db.Database.ExecuteSqlCommand("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);
            await _db.Database.ExecuteSqlCommandAsync("exec [SaveMarketGroup] @groupView, @isEdit,@marketDefId", paramGroups, MarketEditFlag, paramMarketDefinitionId);

        }
        public async Task<string> SaveMarketPacks(List<MarketDefinitionPack> marketDefinitionPacks, int MarketDefId)
        {
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
            return "";
        }
        private async Task SaveMarketGroupPack(int marketDefinitionId, List<MarketGroupPacks> marketGroupPacks, int IsEdit)
        {
            var marketGroupPackDt = new DataTable();
            marketGroupPackDt.Columns.Add("Id", typeof(int));
            marketGroupPackDt.Columns.Add("PFC", typeof(string));
            marketGroupPackDt.Columns.Add("GroupId", typeof(int));
            marketGroupPackDt.Columns.Add("MarketDefinitionId", typeof(int));

            foreach (var item in marketGroupPacks)
            {
                item.MarketDefinitionId = marketDefinitionId;
                marketGroupPackDt.Rows.Add(item.Id, item.PFC, item.GroupId, item.MarketDefinitionId);
            }

            SqlParameter MarketEditFlag = new SqlParameter("@isEdit", IsEdit);
            SqlParameter paramGroups = new SqlParameter("@marketGroupPack", marketGroupPackDt);
            paramGroups.SqlDbType = System.Data.SqlDbType.Structured;
            paramGroups.TypeName = "typMarketGroupPack";
            SqlParameter paramMarketDefinitionId = new SqlParameter("@marketDefinitionId", marketDefinitionId);

            //db.Database.ExecuteSqlCommand("exec EditOutletBrickAllocations @territoryID,@TVP", territoryID, paramOutletBricks);
            await _db.Database.ExecuteSqlCommandAsync("exec [SaveMarketGroupPacks] @marketGroupPack,@isEdit,@marketDefinitionId", paramGroups, MarketEditFlag, paramMarketDefinitionId);

        }

        private async Task SaveMarketGroupFilter(int marketDefinitionId, List<MarketGroupFilter> marketGroupFilters, int isEdit)
        {
            var marketGroupFilterDt = new DataTable();
            marketGroupFilterDt.Columns.Add("Id", typeof(int));
            marketGroupFilterDt.Columns.Add("Name", typeof(string));
            marketGroupFilterDt.Columns.Add("Criteria", typeof(string));
            marketGroupFilterDt.Columns.Add("Values", typeof(string));
            marketGroupFilterDt.Columns.Add("IsEnabled", typeof(Boolean));
            marketGroupFilterDt.Columns.Add("IsAttribute", typeof(Boolean));
            marketGroupFilterDt.Columns.Add("GroupId", typeof(int));
            marketGroupFilterDt.Columns.Add("AttributeId", typeof(int));
            marketGroupFilterDt.Columns.Add("MarketDefinitionId", typeof(int));

            foreach (var item in marketGroupFilters)
            {
                item.MarketDefinitionId = marketDefinitionId;
                marketGroupFilterDt.Rows.Add(item.Id, item.Name, item.Criteria, item.Values, item.IsEnabled, item.IsAttribute,
                    item.GroupId, item.AttributeId, item.MarketDefinitionId);
            }

            SqlParameter marketEditFlag = new SqlParameter("@isEdit", isEdit);
            SqlParameter paramGroups = new SqlParameter("@marketGroupFilter", marketGroupFilterDt);
            paramGroups.SqlDbType = System.Data.SqlDbType.Structured;
            paramGroups.TypeName = "typMarketGroupFilter";
            SqlParameter paramMarketDefinitionId = new SqlParameter("@marketDefinitionId", marketDefinitionId);

            await _db.Database.ExecuteSqlCommandAsync("exec [SaveMarketGroupFilters] @marketGroupFilter,@isEdit,@marketDefinitionId", paramGroups, marketEditFlag, paramMarketDefinitionId);
        }
    }
}

