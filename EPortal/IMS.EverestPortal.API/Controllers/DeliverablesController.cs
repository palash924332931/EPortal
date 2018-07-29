using IMS.EverestPortal.API.Audit;
using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Subscription;
using IMS.EverestPortal.API.Models.Territory;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Web.Http;

namespace IMS.EverestPortal.API.Controllers
{
    //[EnableCors(origins: "*", headers: "*", methods: "*")]
    [Authorize]
    public class DeliverablesController : ApiController
    {
        private EverestPortalContext dbContext = new EverestPortalContext();


        /// <summary>
        /// This method updates the Existing  Deliverables
        /// </summary>
        /// <param name="request"></param>
        /// <returns>Http Response Message </returns>
        [Route("api/deliverables/updateDeliverables")]
        [HttpPost]
        public HttpResponseMessage updateDeliverables([FromBody]DeliverablesDTO request)
        {
            if (request != null)
            {
                var validationResult = validateDeliverable(request);
                if (!validationResult.isSuccess) return Request.CreateResponse(HttpStatusCode.OK, new { message = validationResult.message, validationResult.isSuccess });

                UpdateDeliverables(request);

                return Request.CreateResponse(HttpStatusCode.Created, new { message = validationResult.message, validationResult.isSuccess });
            }

            return Request.CreateResponse(HttpStatusCode.Created);
        }

        public void UpdateDeliverables(DeliverablesDTO request)
        {
            using (var transaction = dbContext.Database.BeginTransaction())
            {
                Deliverables ObjDelivery = dbContext.deliverables.Where(p => p.DeliverableId == request.DeliverableId).SingleOrDefault();
                if (ObjDelivery != null)
                {
                    ObjDelivery.Census = request.Census;
                    ObjDelivery.EndDate = request.EndDate;
                    ObjDelivery.FrequencyTypeId = request.FrequencyTypeId;
                    ObjDelivery.FrequencyId = request.FrequencyId == 0 ? (int?)null : request.FrequencyId;
                    ObjDelivery.LastModified = DateTime.Now;
                    ObjDelivery.OneKey = request.OneKey;
                    ObjDelivery.PackException = request.PackException;
                    ObjDelivery.PeriodId = request.PeriodId;
                    ObjDelivery.probe = request.probe;
                    ObjDelivery.ReportWriterId = request.ReportWriterId == 0 ? (int?)null : request.ReportWriterId;
                    ObjDelivery.RestrictionId = request.RestrictionId;
                    ObjDelivery.StartDate = request.StartDate;
                    ObjDelivery.SubscriptionId = request.SubscriptionId;
                    if (request.DeliveryTypeId == 3) //Only for IAM deliverable
                        ObjDelivery.Mask = request.Mask;

                    var delMktList = dbContext.DeliveryMarkets.Where(q => q.DeliverableId == ObjDelivery.DeliverableId).ToList();
                    foreach (var obj in delMktList)
                    {
                        int mktDefid = obj.MarketDefId;
                        bool isfound = false;
                        foreach (var mkt in request.marketDefs)
                        {
                            int mktid = mkt.Id;
                            if (mktDefid == mktid)
                            {
                                isfound = true;
                            }
                        }
                        if (isfound == false)
                        {
                            dbContext.DeliveryMarkets.Remove(obj);
                        }
                    }
                    // Update dependent objects such as Mkt and Territories associated with Deliverable
                    foreach (var mkt in request.marketDefs)
                    {
                        int mktid = mkt.Id;
                        //DeliveryMarket o = new DeliveryMarket();
                        DeliveryMarket oDM = dbContext.DeliveryMarkets.FirstOrDefault(q => q.DeliverableId == ObjDelivery.DeliverableId && q.MarketDefId == mktid);
                        if (oDM != null)
                        {
                            //if (mkt.isDeleted == true)
                            //{
                            //    dbContext.DeliveryMarkets.Remove(oDM);
                            //}
                        }
                        else
                        {
                            dbContext.DeliveryMarkets.Add(new DeliveryMarket { DeliverableId = ObjDelivery.DeliverableId, MarketDefId = mktid });
                        }
                    }
                    var delTerList = dbContext.DeliveryTerritories.Where(q => q.DeliverableId == ObjDelivery.DeliverableId).ToList();
                    foreach (var obj in delTerList)
                    {
                        int terDefid = obj.TerritoryId;
                        bool isfound = false;
                        foreach (var mkt in request.territories)
                        {
                            int terid = mkt.Id;
                            if (terDefid == terid)
                            {
                                isfound = true;
                            }
                        }
                        if (isfound == false)
                        {
                            dbContext.DeliveryTerritories.Remove(obj);
                        }
                    }
                    foreach (var ter in request.territories)
                    {
                        int terid = ter.Id;
                        DeliveryTerritory oDT = dbContext.DeliveryTerritories.FirstOrDefault(q => q.DeliverableId == ObjDelivery.DeliverableId && q.TerritoryId == terid);
                        if (oDT != null)
                        {
                            //if (ter.isDeleted == true)
                            //{
                            //    dbContext.DeliveryTerritories.Remove(oDT);
                            //}
                        }
                        else
                        {
                            dbContext.DeliveryTerritories.Add(new DeliveryTerritory { DeliverableId = ObjDelivery.DeliverableId, TerritoryId = terid });
                        }
                    }
                    var delClientList = dbContext.DeliveryClients.Where(q => q.DeliverableId == ObjDelivery.DeliverableId).ToList();
                    foreach (var obj in delClientList)
                    {
                        int clientid = obj.ClientId;
                        bool isfound = false;
                        foreach (var mkt in request.clients.Where(x => x.IsThirdparty == false))
                        {
                            int id = mkt.Id;
                            if (clientid == id)
                            {
                                isfound = true;
                            }
                        }
                        if (isfound == false)
                        {
                            dbContext.DeliveryClients.Remove(obj);
                        }
                    }
                    foreach (var cl in request.clients.Where(x => x.IsThirdparty == false))
                    {
                        int clientid = cl.Id;
                        DeliveryClient oDC = dbContext.DeliveryClients.FirstOrDefault(q => q.DeliverableId == ObjDelivery.DeliverableId && q.ClientId == clientid);
                        if (oDC != null)
                        {
                            //if (cl.isDeleted == true)
                            //{
                            //    dbContext.DeliveryClients.Remove(oDC);
                            //}
                        }
                        else
                        {
                            dbContext.DeliveryClients.Add(new DeliveryClient { DeliverableId = ObjDelivery.DeliverableId, ClientId = clientid });
                        }
                    }
                    var delThirdParyList = dbContext.DeliveryThirdParties.Where(q => q.DeliverableId == ObjDelivery.DeliverableId).ToList();
                    foreach (var obj in delThirdParyList)
                    {
                        int clientid = obj.ThirdPartyId;
                        bool isfound = false;
                        foreach (var mkt in request.clients.Where(x => x.IsThirdparty == true))
                        {
                            int id = mkt.Id;
                            if (clientid == id)
                            {
                                isfound = true;
                            }
                        }
                        if (isfound == false)
                        {
                            dbContext.DeliveryThirdParties.Remove(obj);
                        }
                    }
                    foreach (var cl in request.clients.Where(x => x.IsThirdparty == true))
                    {
                        int clientid = cl.Id;
                        DeliveryThirdParty oDC = dbContext.DeliveryThirdParties.FirstOrDefault(q => q.DeliverableId == ObjDelivery.DeliverableId && q.ThirdPartyId == clientid);
                        if (oDC != null)
                        {
                            //if (cl.isDeleted == true)
                            //{
                            //    dbContext.DeliveryClients.Remove(oDC);
                            //}
                        }
                        else
                        {
                            dbContext.DeliveryThirdParties.Add(new DeliveryThirdParty { DeliverableId = ObjDelivery.DeliverableId, ThirdPartyId = clientid });
                        }
                    }

                    //Subchannels
                    //delete if already exists
                    if (request.SubChannelsDTO != null)
                    {
                        var subChannelsToDelete = dbContext.SubChannels.Where(s => s.DeliverableId == request.DeliverableId);
                        dbContext.SubChannels.RemoveRange(subChannelsToDelete);

                        //insert the subchannels
                        foreach (var subChannel in request.SubChannelsDTO)
                        {
                            var selectedEntityType = subChannel.EntityTypes.Where(e => e.IsSelected == true).Select(x => x.EntityTypeId);
                            foreach (var entity in selectedEntityType)
                            {
                                dbContext.SubChannels.Add(new SubChannels { DeliverableId = ObjDelivery.DeliverableId, EntityTypeId = entity });
                            }
                        }
                    }

                    if (request.ReportNo != null)
                    {
                        var irpReportNo = dbContext.DeliveryReports.SingleOrDefault(d => d.DeliverableId == request.DeliverableId);
                        if (irpReportNo != null)
                        {
                            irpReportNo.ReportNo = Convert.ToInt32(request.ReportNo);
                        }
                    }

                    dbContext.SaveChanges();
                    transaction.Commit();
                }
            }
        }

        private dynamic validateDeliverable(DeliverablesDTO request)
        {
            var isSuccess = true;
            var msg = "";

            using (EverestPortalContext context = new EverestPortalContext()) {
                var deliverable = context.deliverables.FirstOrDefault(d => d.DeliverableId == request.DeliverableId);
                

                if (request.ReportNo == null && deliverable.DeliveryTypeId == 3)
                {
                    msg = "Report number cannot be empty for IAM deliverable.";
                    isSuccess = false;
                }
                else if (request.ReportNo != null)
                {
                    if (request.ReportNo <= 0)
                    {
                        msg = "Report number needs to be greater than zero.";
                        isSuccess = false;
                    }
                    else {
                        var reportNoEntry = (from d in context.deliverables
                                             join sub in context.subscription
                                             on d.SubscriptionId equals sub.SubscriptionId
                                             join cl in context.Clients
                                             on sub.ClientId equals cl.Id
                                             join dr in context.DeliveryReports
                                             on d.DeliverableId equals dr.DeliverableId
                                             where dr.ReportNo == request.ReportNo && cl.Id == request.ClientId && d.DeliverableId != request.DeliverableId
                                             select d
                                          ).ToList();

                        if (reportNoEntry != null && reportNoEntry.Count > 0) {
                            msg = "Report number already exists for the client.";
                            isSuccess = false;
                        }
                    }

                }


            }


                

            var result = new
            {
                message = msg,
                isSuccess
            };

            return result;
        }


        /// <summary>
        ///  Get Report  Level restriction for Deliverables.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="tid"></param>
        /// <param name="clientid"></param>
        /// <returns>Restriction values as string </returns>
        [Route("api/deliverables/getRestrictions")]
        [HttpGet]
        public string getRestrictions(int id, string tid, int clientid)
        {
            List<RestrictionDTO> lstRes = new List<RestrictionDTO>();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return JsonConvert.SerializeObject(lstRes, Formatting.Indented,
                                         new JsonSerializerSettings
                                         {
                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                         });

            string json = "";
            int terLevelCnt = 8;
            List<RestrictionDTO> lstResest = new List<RestrictionDTO>();
            List<Level> lstLevel = new List<Level>();
            if (tid == null || tid == "")
            {
                var delObj = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == id);
                if (delObj != null)
                {
                    if (delObj.subscription.service.Name.ToLower() != "audit")
                    {

                        var delTerList = dbContext.DeliveryTerritories.Where(p => p.DeliverableId == id).ToList();
                        if (delTerList != null && delTerList.Count() > 0)
                        {
                            foreach (var obj in delTerList)
                            {

                                int a = obj.territory.Levels.Count;
                                if (a < terLevelCnt) terLevelCnt = a;

                                var lstNames = obj.territory.Levels.ToList();
                                foreach (var o in lstNames) { lstLevel.Add(o); }
                                // lstResest.Add(new RestrictionDTO { Id = obj.TerritoryId });
                            }

                            for (int i = 1; i <= terLevelCnt; i++)
                            {
                                var result = lstLevel.Where(x => x.LevelNumber == i).Select(x => x.Name.ToUpper()).ToArray();
                                var disRes = result.Distinct();

                                lstRes.Add(new RestrictionDTO { Id = i, Name = String.Join(",", disRes) });
                            }

                            //var res = dbContext.Restrictions.ToList();
                            //json = JsonConvert.SerializeObject(lstRes, Formatting.Indented,
                            //            new JsonSerializerSettings
                            //            {
                            //                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            //            });
                        }
                    }
                    else
                    {
                        lstRes.Add(new RestrictionDTO { Id = 1, Name = "National" });
                    }
                }
            }
            else
            {
                string[] tempID = tid.Split(new string[] { "," }, StringSplitOptions.None);
                int[] terID = new int[tempID.Length];

                for (int i = 0; i < tempID.Length; i++)
                    terID[i] = Convert.ToInt32(tempID[i]);
                // List<RestrictionDTO> lstRes = new List<RestrictionDTO>();
                var delObj = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == id);
                if (delObj != null)
                {
                    if (delObj.subscription.service.Name.ToLower() != "audit")
                    {

                        //var delTerList = dbContext.DeliveryTerritories.Where(p => p.DeliverableId == id).ToList();
                        var delTerList = dbContext.Territories.Where(o => terID.Contains(o.Id)).ToList();
                        if (delTerList != null && delTerList.Count() > 0)
                        {
                            foreach (var obj in delTerList)
                            {

                                //int a = obj.territory.Levels.Count;
                                int a = obj.Levels.Count;
                                if (a < terLevelCnt) terLevelCnt = a;

                                var lstNames = obj.Levels.ToList();
                                foreach (var o in lstNames) { lstLevel.Add(o); }

                            }
                            // List<RestrictionDTO> lstRes = new List<RestrictionDTO>();
                            for (int i = 1; i <= terLevelCnt; i++)
                            {
                                //   lstRes.Add(new RestrictionDTO { Id = i });
                                // var result = String.Join(",", lstLevel.Where(x => x.LevelNumber == i).Select(x => x.Name).ToArray());
                                var result = lstLevel.Where(x => x.LevelNumber == i).Select(x => x.Name).ToArray();
                                var disRes = result.Distinct();

                                lstRes.Add(new RestrictionDTO { Id = i, Name = String.Join(",", disRes) });
                            }

                        }
                    }
                    else
                    {
                        lstRes.Add(new RestrictionDTO { Id = 1, Name = "National" });
                    }
                }


            }
            json = JsonConvert.SerializeObject(lstRes, Formatting.Indented,
                                        new JsonSerializerSettings
                                        {
                                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                        });
            return json;
        }


        /// <summary>
        /// This method gets Report Writer values
        /// </summary>
        /// <param name="id"></param>
        /// <param name="clientid"></param>
        /// <returns></returns>
        [Route("api/deliverables/getReportWriters")]
        [HttpGet]
        public string getReportWriters(int id, int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return JsonConvert.SerializeObject(new List<object>(), Formatting.Indented,
                                         new JsonSerializerSettings
                                         {
                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                         });

            var objDel = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == id);
            //int delTypeid = objDel.reportWriter.DeliveryTypeId;
            int delTypeid = objDel.DeliveryTypeId;
            var rptWriter = dbContext.ReportWriters.Where(x => x.DeliveryTypeId == delTypeid).ToList();
            //var rptWriter = dbContext.ReportWriters.ToList();

            int serviceId = objDel.subscription.ServiceId;
            var objConfig = dbContext.ServiceConfigurations.Where(x => x.Serviceid == serviceId && x.configuation.ToLower() == "reportwriter").ToList();
            if (objConfig != null && objConfig.Count > 0)
            {
                HashSet<int> prtIds = new HashSet<int>(objConfig.Select(x => x.value));
                rptWriter.RemoveAll(y => !prtIds.Contains(y.ReportWriterId));
            }
            var json = JsonConvert.SerializeObject(rptWriter, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

       
        [Route("api/deliverables/getPeriodForFrequency")]
        [HttpGet]
        public List<PeriodForFrequency> getPeriodForFrequency()
        {
            List<PeriodForFrequency> periods = new List<PeriodForFrequency>();
            using (var context = new EverestPortalContext())
            {
                periods = context.PeriodForFrequencies.ToList();
            }
            return periods;
        }

        /// <summary>
        ///  Get Frequencies for the client
        /// </summary>
        /// <param name="id"></param>
        /// <param name="clientid"></param>
        /// <returns></returns>
        [Route("api/deliverables/getFrequncy")]
        [HttpGet]
        public string getFrequncy(int id, int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return JsonConvert.SerializeObject(new List<object>(), Formatting.Indented,
                                         new JsonSerializerSettings
                                         {
                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                         });

            string json = string.Empty;
            Deliverables objDelivery = new Deliverables();
            objDelivery = dbContext.deliverables.FirstOrDefault(p => p.DeliverableId == id);
            //List<Frequency>  objFreq= GetFrequncyList(objDelivery.frequencyType.Name);
            if (objDelivery != null)
            {
                var FreqList = dbContext.Frequencies.Where(x => x.FrequencyTypeId == objDelivery.FrequencyTypeId).ToList();

                int serviceId = objDelivery.subscription.ServiceId;
                var objConfig = dbContext.ServiceConfigurations.Where(x => x.Serviceid == serviceId && x.configuation.ToLower() == "frequency").ToList();

                if (objConfig != null && objConfig.Count > 0)
                {
                    HashSet<int> freqIds = new HashSet<int>(objConfig.Select(x => x.value));
                    FreqList.RemoveAll(y => !freqIds.Contains(y.FrequencyId));
                    //FreqList.RemoveAll(y => y.FrequencyId != objConfig.value);
                }
                json = JsonConvert.SerializeObject(FreqList, Formatting.Indented,
                           new JsonSerializerSettings
                           {
                               ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                           });
            }
            return json;
        }

        /// <summary>
        ///  Get Periods 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="clientid"></param>
        /// <returns>Period Value as String</returns>
        [Route("api/deliverables/getPeriod")]
        [HttpGet]
        public string getPeriod(int id, int clientid)
        {
            List<Period> period = new List<Period>();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return JsonConvert.SerializeObject(period, Formatting.Indented,
                                         new JsonSerializerSettings
                                         {
                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                         });

            period = dbContext.Periods.ToList();

            Deliverables objDelivery = new Deliverables();
            objDelivery = dbContext.deliverables.FirstOrDefault(p => p.DeliverableId == id);
            if (objDelivery != null)
            {
                int serviceId = objDelivery.subscription.ServiceId;

                var objConfig = dbContext.ServiceConfigurations.Where(x => x.Serviceid == serviceId && x.configuation.ToLower() == "period").ToList();

                if (objConfig != null && objConfig.Count > 0)
                {
                    HashSet<int> periodIds = new HashSet<int>(objConfig.Select(x => x.value));
                    period.RemoveAll(y => !periodIds.Contains(y.PeriodId));
                    //period.RemoveAll(y => y.PeriodId != objConfig.value);
                }


                //Removes the 160 weeks from the periods from the collection if service is not nelson feed service
                var nFeedService = dbContext.Services.FirstOrDefault(s => s.Name == "Nielsen feed");
                if (nFeedService != null)
                {
                    if (serviceId != nFeedService.ServiceId)
                    {
                        period.RemoveAll(p => p.Name == "160 Weeks");
                    }

                }

            }
            var json = JsonConvert.SerializeObject(period, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

        /// <summary>
        ///  Get Market Definitions for Clients
        /// </summary>
        /// <param name="clientid"></param>
        /// <param name="delid"></param>
        /// <returns></returns>
        [Route("api/deliverables/getClientMarketDef")]
        [HttpGet]
        public string getClientMarketDef(int clientid, int delid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return "";

            //Deliverables objDelivery = new Deliverables();
            //objDelivery = dbContext.deliverables.FirstOrDefault(p => p.DeliverableId == id);
            var objClient = dbContext.MarketDefinitions.Where(u => u.ClientId == clientid).ToList();
            int subid = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == delid).SubscriptionId;
            var subMktList = dbContext.subscriptionMarket.Where(u => u.SubscriptionId == subid).ToList();
            HashSet<int> subMktIDs = new HashSet<int>(subMktList.Select(s => s.MarketBaseId));
            //bool isValidMktDef = false;
            List<ClientMarketDefDTO> lstmrket = new List<ClientMarketDefDTO>();
            foreach (var obj in objClient)
            {
                if (validateMarketDef(obj.MarketDefinitionBaseMaps, subMktIDs))
                {
                    ClientMarketDefDTO mktObj = new ClientMarketDefDTO();
                    mktObj.clientId = obj.ClientId;
                    mktObj.Id = obj.Id;
                    mktObj.Name = obj.Name;
                    List<MarketBaseDTO> lstMktBase = new List<MarketBaseDTO>();
                    foreach (var o in obj.MarketDefinitionBaseMaps)
                    {
                        MarketBaseDTO mktBase = new MarketBaseDTO();
                        mktBase.Id = o.MarketBase.Id;
                        mktBase.Name = o.MarketBase.Name + " " + o.MarketBase.Suffix;
                        mktBase.Description = o.MarketBase.Description;
                        mktBase.DurationFrom = o.MarketBase.DurationFrom;
                        mktBase.DurationTo = o.MarketBase.DurationTo;
                        lstMktBase.Add(mktBase);
                    }
                    mktObj.marketBaseDTOs = lstMktBase;
                    lstmrket.Add(mktObj);
                }
            }
            var json = JsonConvert.SerializeObject(lstmrket, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        private bool validateMarketDef(List<MarketDefinitionBaseMap> mktDefBaseMaps, HashSet<int> subMktIDs)
        {
            bool isValid = false;
            if (mktDefBaseMaps.Count == 0)
            {
                return false;
            }
            //var res= mktDefBaseMaps.Where(m => !subMktIDs.Contains(m.MarketBaseId));
            foreach (var obj in mktDefBaseMaps)
            {
                //isValid = false;
                if (subMktIDs.Contains(obj.MarketBaseId))
                {
                    isValid = true;
                    break;
                }

            }
            return isValid;
        }
        [Route("api/deliverables/GetClientTerritories")]
        [HttpGet]
        public string GetClientTerritories(int clientid, int delid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return "";
            List<ClientTerritoryDTO> TerritoryList = new List<ClientTerritoryDTO>();
            //Deliverables objDelivery = new Deliverables();
            var objDelivery = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == delid);
            if (objDelivery != null)
            {
                string TBase = objDelivery.subscription.serviceTerritory.TerritoryBase;
                List<Territory> objClientTerritory = new List<Territory>();
                if (TBase.ToLower() == "brick")
                {
                    objClientTerritory = dbContext.Territories.Where(u => u.Client_Id == clientid && u.IsBrickBased == true).OrderBy(p => p.Name).ToList<Territory>();
                }
                else if (TBase.ToLower() == "outlet")
                {
                    objClientTerritory = dbContext.Territories.Where(u => u.Client_Id == clientid && u.IsBrickBased == false).OrderBy(p => p.Name).ToList<Territory>();
                }
                else if (TBase.ToLower() == "both")
                {
                    objClientTerritory = dbContext.Territories.Where(u => u.Client_Id == clientid).OrderBy(p => p.Name).ToList<Territory>();
                }
                if (objClientTerritory != null && objClientTerritory.Count > 0)
                {
                    foreach (var obj in objClientTerritory)
                    {
                        TerritoryList.Add(new ClientTerritoryDTO
                        {
                            Id = obj.Id,
                            Name = GetTerritoryName(obj),
                            clientId = obj.Client_Id,
                            TerritoryBase = (obj.IsBrickBased == true ? "Brick" : "Outlet")
                        });
                        //obj.RootGroup = new Group();
                    }
                }
            }
            var json = JsonConvert.SerializeObject(TerritoryList, Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }

        /// <summary>
        /// Get Client info
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Route("api/deliverables/GetClients")]
        [HttpGet]
        public string GetClients(int id)
        {
            var objClient = dbContext.Clients.SingleOrDefault(p => p.Id == id);
            List<ClientDTO> clientList = new List<ClientDTO>();
            clientList.Add(new ClientDTO { Id = objClient.Id, Name = objClient.Name, IsThirdparty = false });
            if (objClient.DivisionOf != null)
            {
                var objdiv = dbContext.Clients.SingleOrDefault(p => p.Id == objClient.DivisionOf);
                clientList.Add(new ClientDTO { Id = objdiv.Id, Name = objdiv.Name, IsThirdparty = false });
            }
            //foreach (var o in objClient)
            //{
            //    clientList.Add(new ClientDTO { Id = o.Id, Name = o.Name, IsThirdparty = false });
            //}
            var objThrdParty = dbContext.ThirdParties.Where(x => x.Active != false).ToList();
            foreach (var o in objThrdParty)
            {
                clientList.Add(new ClientDTO { Id = o.ThirdPartyId, Name = o.Name, IsThirdparty = true });
            }
            var json = JsonConvert.SerializeObject(clientList.OrderBy(s => s.Name).ToList(), Formatting.Indented,
                        new JsonSerializerSettings
                        {
                            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                        });

            return json;
        }
        /// <summary>
        /// Get Deliverables for Clients
        /// </summary>
        /// <param name="id"></param>
        /// <param name="clientid"></param>
        /// <returns></returns>
        [Route("api/deliverables/GetDeliverableByID")]
        [HttpGet]
        public string GetDeliverableByID(int id, int clientid)
        {
            DeliverablesDTO DeliveryObj = new DeliverablesDTO();
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return JsonConvert.SerializeObject(DeliveryObj, Formatting.Indented,
                                                         new JsonSerializerSettings
                                                         {
                                                             ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                                                         });

            var objDeliverable = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == id);
            string json = string.Empty;
            if (objDeliverable != null && objDeliverable.subscription.Active == true)
            {
                //foreach (var obj in objDeliverable)
                //{
                DeliveryObj.ClientId = objDeliverable.subscription.ClientId;
                DeliveryObj.ClientName = objDeliverable.subscription.client.Name;
                DeliveryObj.DeliverableId = objDeliverable.DeliverableId;
                DeliveryObj.DisplayName = getSubscriptionName(objDeliverable);
                var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var endDate = new DateTime(DateTime.Now.Year, 12, 1);
                DeliveryObj.StartDate = objDeliverable.StartDate == null ? startDate : objDeliverable.StartDate;
                DeliveryObj.EndDate = objDeliverable.EndDate == null ? endDate : objDeliverable.EndDate;
                DeliveryObj.FrequencyTypeId = objDeliverable.FrequencyTypeId;
                DeliveryObj.FrequencyId = (objDeliverable.FrequencyId == null ? 0 : objDeliverable.FrequencyId.Value);
                DeliveryObj.LastModified = objDeliverable.LastModified;
                DeliveryObj.ModifiedBy = objDeliverable.ModifiedBy;

                DeliveryObj.PeriodId = objDeliverable.PeriodId;
                DeliveryObj.ReportWriterId = objDeliverable.ReportWriterId == null ? 0 : objDeliverable.ReportWriterId.Value;
                //DeliveryObj.RestrictionId = objDeliverable.RestrictionId.Value;
                DeliveryObj.RestrictionId = (objDeliverable.RestrictionId == null ? 0 : objDeliverable.RestrictionId.Value);

                if (objDeliverable.subscription.service.Name.ToUpper() == "AUDIT")
                {
                    DeliveryObj.RestrictionId = 1;
                    //DeliveryObj.RestrictionName = "1-National";
                }
                DeliveryObj.SubscriptionId = objDeliverable.SubscriptionId;
                DeliveryObj.SubServiceTerritoryId = objDeliverable.subscription.ServiceTerritoryId;

                

                DeliveryObj.OneKey = objDeliverable.OneKey == null ? false : objDeliverable.OneKey.Value;
                DeliveryObj.PackException = objDeliverable.PackException == null ? false : objDeliverable.PackException.Value;
                DeliveryObj.probe = objDeliverable.probe == null ? false : objDeliverable.probe.Value;
                DeliveryObj.Census = objDeliverable.Census == null ? false : objDeliverable.Census.Value;
                DeliveryObj.IsOneKeyAvailable = objDeliverable.OneKey == null || objDeliverable.OneKey.Value == false ? false : true;
                DeliveryObj.IsPackExcAvailable = objDeliverable.PackException == null || objDeliverable.PackException.Value == false ? false : true;
                DeliveryObj.IsProbeAvailable = objDeliverable.probe == null || objDeliverable.probe.Value == false ? false : true;
                DeliveryObj.IsCensusAvailable = objDeliverable.Census == null || objDeliverable.Census.Value == false ? false : true;
                DeliveryObj.DeliveryTypeId = objDeliverable.DeliveryTypeId;
                DeliveryObj.Mask = objDeliverable.Mask == null ? false : objDeliverable.Mask.Value;

                List<ClientMarketDefDTO> mktList = GetClientMarketDefDTO(id);

                if (mktList != null && mktList.Count > 0)
                {
                    mktList = mktList.OrderBy(mk => mk.Name).ToList();
                }
                DeliveryObj.marketDefs = mktList;
                List<ClientTerritoryDTO> terList = GetDeliverablesTerritories(id);

                if (terList != null && terList.Count > 0)
                {
                    terList = terList.OrderBy(tl => tl.Name).ToList();
                }
                DeliveryObj.territories = terList;
                List<ClientDTO> clientList = GetDeliverablesClientList(id);
                DeliveryObj.clients = clientList.OrderBy(y => y.Name).ToList();

                //Subchannels
                DeliveryObj.SubChannelsDTO = GetSubchannels(id);

                DeliveryObj.ReportNo = getIRPReportNo(id);

                json = JsonConvert.SerializeObject(DeliveryObj, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            });
                //}
            }
            return json;
        }

        public List<ClientDTO> GetDeliverablesClientList(int id)
        {
            var cList = dbContext.DeliveryClients.Where(z => z.DeliverableId == id).ToList();
            List<ClientDTO> clientList = new List<ClientDTO>();
            foreach (var c in cList)
            {
                ClientDTO o = new ClientDTO();
                o.Id = c.client.Id;
                o.Name = c.client.Name;
                o.IsThirdparty = false;
                clientList.Add(o);
            }
            var tpartyList = dbContext.DeliveryThirdParties.Where(o => o.DeliverableId == id).ToList();
            foreach (var c in tpartyList)
            {
                ClientDTO o = new ClientDTO();
                o.Id = c.thirdParty.ThirdPartyId;
                o.Name = c.thirdParty.Name;
                o.IsThirdparty = true;
                clientList.Add(o);
            }

            return clientList;
        }

        public List<ClientTerritoryDTO> GetDeliverablesTerritories(int deliverableId)
        {
            var tList = dbContext.DeliveryTerritories.Where(y => y.DeliverableId == deliverableId).ToList();
            List<ClientTerritoryDTO> terList = new List<ClientTerritoryDTO>();
            foreach (var o in tList)
            {
                ClientTerritoryDTO objTer = new ClientTerritoryDTO();
                objTer.Id = o.territory.Id;
                objTer.Name = GetTerritoryName(o.territory);//o.territory.Name;
                objTer.TerritoryBase = (o.territory.IsBrickBased == true ? "Brick" : "Outlet");
                terList.Add(objTer);
            }

            return terList;
        }

        public List<ClientMarketDefDTO> GetClientMarketDefDTO(int deliverableId)
        {
            var mktlst = dbContext.DeliveryMarkets.Where(x => x.DeliverableId == deliverableId).ToList();
            List<ClientMarketDefDTO> mktList = new List<ClientMarketDefDTO>();

            foreach (var oMkt in mktlst)
            {
                ClientMarketDefDTO mktObj = new ClientMarketDefDTO();
                if (oMkt != null)
                {
                    mktObj.Id = oMkt.marketDefinition.Id;
                    mktObj.Name = oMkt.marketDefinition.Name;
                   
                    List<MarketBaseDTO> lstMktBase = new List<MarketBaseDTO>();
                    foreach (var m in oMkt.marketDefinition.MarketDefinitionBaseMaps)
                    {
                        MarketBaseDTO mktBase = new MarketBaseDTO();
                        mktBase.Id = m.MarketBase.Id;
                        mktBase.Name = m.MarketBase.Name + " " + m.MarketBase.Suffix;
                        mktBase.Description = m.MarketBase.Description;
                        mktBase.DurationFrom = m.MarketBase.DurationFrom;
                        mktBase.DurationTo = m.MarketBase.DurationTo;
                        lstMktBase.Add(mktBase);
                    }
                    mktObj.marketBaseDTOs = lstMktBase;
                    mktList.Add(mktObj);
                }
            }

            return mktList;
        }

        /// <summary>
        /// Get Subscription Name 
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        private string getSubscriptionName(Deliverables obj)
        {
            string deliveryName = string.Empty;
            deliveryName = obj.subscription.country.Name + " " + obj.subscription.service.Name + " " + obj.subscription.dataType.Name
                + " " + obj.subscription.source.Name + " ";
            //deliveryName = deliveryName + obj.reportWriter.deliveryType.Name + " " + obj.frequencyType.Name;
            deliveryName = deliveryName + obj.deliveryType.Name + " " + obj.frequencyType.Name;
            return deliveryName;
        }

        /// <summary>
        /// Get Deliverables by Client
        /// </summary>
        /// <param name="clientid"></param>
        /// <returns></returns>
        [Route("api/deliverables/GetDeliverablesByClient")]
        [HttpGet]
        public string GetDeliverablesByClient(int clientid)
        {
            AuthController objAuth = new AuthController();
                if (objAuth.CheckUserClients(clientid) == 0)
                    return "";
                List<DeliverablesDTO> DeliverablesDTOList = new List<DeliverablesDTO>();
                var DeliverableList = dbContext.deliverables.Where(p => p.subscription.ClientId == clientid && p.subscription.EndDate.Year >= DateTime.Now.Year).ToList();
                var deliveryHistory = (from sub in dbContext.Deliverables_History
                                       where sub.EndDate.Year >= DateTime.Now.Year
                                       group sub by sub.DeliverableId into tempGrp
                                       let maxVersion = tempGrp.Max(x => x.Version)
                                       select new
                                       {
                                           DeliverableId = tempGrp.Key,
                                           LastSaved = tempGrp.FirstOrDefault(y => y.Version == maxVersion).LastSaved,
                                           MaxVer = maxVersion
                                       }).ToList();
                string json = string.Empty;
                if (DeliverableList != null && DeliverableList.Count > 0)
                {
                    foreach (var objDeliverable in DeliverableList)
                    {
                        if (objDeliverable.subscription.Active == true)
                        {
                            DeliverablesDTO DeliveryObj = new DeliverablesDTO();
                            //foreach (var obj in objDeliverable)
                            //{
                            DeliveryObj.ClientId = objDeliverable.subscription.ClientId;
                            DeliveryObj.ClientName = objDeliverable.subscription.client.Name;
                            DeliveryObj.DeliverableId = objDeliverable.DeliverableId;
                            DeliveryObj.DeliveryTypeId = objDeliverable.DeliveryTypeId;

                            DeliveryObj.DisplayName = getSubscriptionName(objDeliverable);
                            var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                            var endDate = new DateTime(DateTime.Now.Year, 12, 1);
                            DeliveryObj.StartDate = objDeliverable.StartDate == null ? startDate : objDeliverable.StartDate;
                            DeliveryObj.EndDate = objDeliverable.EndDate == null ? endDate : objDeliverable.EndDate;
                            DeliveryObj.FrequencyTypeId = objDeliverable.FrequencyTypeId;
                            DeliveryObj.FrequencyId = (objDeliverable.FrequencyId == null ? 0 : objDeliverable.FrequencyId.Value);
                            DeliveryObj.FrequencyName = (objDeliverable.frequency == null ? "" : objDeliverable.frequency.Name);
                            DeliveryObj.LastModified = objDeliverable.LastModified;
                            DeliveryObj.ModifiedBy = objDeliverable.ModifiedBy;
                            var res = deliveryHistory.FirstOrDefault(i => i.DeliverableId == objDeliverable.DeliverableId);
                            DeliveryObj.Submitted = (res == null || res.LastSaved != DeliveryObj.LastModified) ? "No" : "Yes";

                            DeliveryObj.PeriodId = objDeliverable.perioid.PeriodId;
                            DeliveryObj.PeriodName = objDeliverable.perioid.Name;
                            DeliveryObj.RestrictionId = (objDeliverable.RestrictionId == null ? 0 : objDeliverable.RestrictionId.Value);
                            List<string> lstRestriction = new List<string>();
                            if (objDeliverable.RestrictionId != null && objDeliverable.RestrictionId > 0)
                            {
                                var delTerList = dbContext.DeliveryTerritories.Where(p => p.DeliverableId == objDeliverable.DeliverableId).ToList();
                                foreach (var objT in delTerList)
                                {
                                    lstRestriction.Add(objDeliverable.RestrictionId + "-" + objT.territory.Levels.SingleOrDefault(x => x.LevelNumber == objDeliverable.RestrictionId).Name);
                                }
                                var distRestriction = lstRestriction.Distinct();
                                DeliveryObj.RestrictionName = string.Join(", ", distRestriction);
                            }

                            if (objDeliverable.subscription.service.Name.ToUpper() == "AUDIT")
                            {
                                DeliveryObj.RestrictionId = 1;
                                DeliveryObj.RestrictionName = "1-National";
                            }


                            DeliveryObj.RestrictionName = string.IsNullOrEmpty(DeliveryObj.RestrictionName) ? "N/A" : DeliveryObj.RestrictionName;

                            DeliveryObj.ReportWriterId = objDeliverable.ReportWriterId == null ? 0 : objDeliverable.ReportWriterId.Value;
                            DeliveryObj.ReportWriterName = objDeliverable.reportWriter == null ? "" : objDeliverable.reportWriter.Code + " " + objDeliverable.reportWriter.Name;

                            DeliveryObj.SubscriptionId = objDeliverable.SubscriptionId;
                            DeliveryObj.SubServiceTerritoryId = objDeliverable.subscription.ServiceTerritoryId;
                            //var locks = dbContext.LockHistories.Where(y => y.DocType == "Delivery" && y.DefId == objDeliverable.DeliverableId).ToList();
                            //if (locks == null || locks.Count == 0)
                            //{
                            //    DeliveryObj.LockType = "";
                            //}
                            //else
                            //{
                            //    if (locks.Count(z => z.LockType == "Edit") > 0)
                            //        DeliveryObj.LockType = "Edit";
                            //    else
                            //        DeliveryObj.LockType = "View";
                            //}
                            //var allocObj = dbContext.ClientRelease.SingleOrDefault(x => x.ClientId == objDeliverable.subscription.ClientId);
                            //if (allocObj == null)
                            //{
                            //    DeliveryObj.IsOneKeyAvailable = false;
                            //    DeliveryObj.IsCensusAvailable = false;
                            //    DeliveryObj.OneKey = null;
                            //    DeliveryObj.Census = null;
                            //}
                            //else
                            //{
                            //    if (allocObj.Census == true)
                            //    {
                            //        DeliveryObj.IsCensusAvailable = true;
                            //        DeliveryObj.Census = objDeliverable.Census == null ? true : objDeliverable.Census.Value;
                            //    }
                            //    else
                            //    {
                            //        DeliveryObj.IsCensusAvailable = false;
                            //        DeliveryObj.Census = null;
                            //    }
                            //    if (allocObj.OneKey == true)
                            //    {
                            //        DeliveryObj.IsOneKeyAvailable = true;
                            //        DeliveryObj.OneKey = objDeliverable.OneKey == null ? true : objDeliverable.OneKey.Value;
                            //    }
                            //    else
                            //    {
                            //        DeliveryObj.IsOneKeyAvailable = false;
                            //        DeliveryObj.OneKey = null;
                            //    }
                            //}
                            //int ProbCount = dbContext.ClientMFR.Count(y => y.ClientId == objDeliverable.subscription.ClientId);
                            //int PackCount = dbContext.ClientPackException.Count(z => z.ClientId == objDeliverable.subscription.ClientId);
                            //if (ProbCount > 0)
                            //{
                            //    DeliveryObj.IsProbeAvailable = true;
                            //    DeliveryObj.probe = objDeliverable.probe == null ? true : objDeliverable.probe.Value;
                            //}
                            //else
                            //{
                            //    DeliveryObj.IsProbeAvailable = false;
                            //    DeliveryObj.probe = false;
                            //}
                            //if (PackCount > 0)
                            //{
                            //    DeliveryObj.IsPackExcAvailable = true;
                            //    DeliveryObj.PackException = objDeliverable.PackException == null ? true : objDeliverable.PackException.Value;
                            //}
                            //else
                            //{
                            //    DeliveryObj.IsPackExcAvailable = false;
                            //    DeliveryObj.PackException = null;
                            //}

                            DeliveryObj.OneKey = objDeliverable.OneKey == null ? false : objDeliverable.OneKey.Value;
                            DeliveryObj.PackException = objDeliverable.PackException == null ? false : objDeliverable.PackException.Value;
                            DeliveryObj.probe = objDeliverable.probe == null ? false : objDeliverable.probe.Value;
                            DeliveryObj.Census = objDeliverable.Census == null ? false : objDeliverable.Census.Value;
                            DeliveryObj.IsOneKeyAvailable = objDeliverable.OneKey == null || objDeliverable.OneKey.Value == false ? false : true;
                            DeliveryObj.IsPackExcAvailable = objDeliverable.PackException == null || objDeliverable.PackException.Value == false ? false : true;
                            DeliveryObj.IsProbeAvailable = objDeliverable.probe == null || objDeliverable.probe.Value == false ? false : true;
                            DeliveryObj.IsCensusAvailable = objDeliverable.Census == null || objDeliverable.Census.Value == false ? false : true;



                            var mktlst = dbContext.DeliveryMarkets.Where(x => x.DeliverableId == objDeliverable.DeliverableId).ToList();
                            List<ClientMarketDefDTO> mktList = new List<ClientMarketDefDTO>();

                            foreach (var oMkt in mktlst)
                            {

                                ClientMarketDefDTO mktObj = new ClientMarketDefDTO();
                                if (oMkt != null)
                                {
                                    mktObj.Id = oMkt.marketDefinition.Id;
                                    mktObj.Name = oMkt.marketDefinition.Name;
                                    //foreach (var o in oMkt.marketDefinition)
                                    //{

                                    List<MarketBaseDTO> lstMktBase = new List<MarketBaseDTO>();
                                    foreach (var m in oMkt.marketDefinition.MarketDefinitionBaseMaps)
                                    {
                                        MarketBaseDTO mktBase = new MarketBaseDTO();
                                        mktBase.Id = m.MarketBase.Id;
                                        mktBase.Name = m.MarketBase.Name + " " + m.MarketBase.Suffix;
                                        mktBase.Description = m.MarketBase.Description;
                                        mktBase.DurationFrom = m.MarketBase.DurationFrom;
                                        mktBase.DurationTo = m.MarketBase.DurationTo;
                                        lstMktBase.Add(mktBase);
                                    }
                                    mktObj.marketBaseDTOs = lstMktBase;
                                    //}

                                    mktList.Add(mktObj);
                                }
                            }
                            if (mktList != null && mktList.Count > 0)
                            {
                                mktList = mktList.OrderBy(mf => mf.Name).ToList();
                            }
                            DeliveryObj.marketDefs = mktList;
                            var tList = dbContext.DeliveryTerritories.Where(y => y.DeliverableId == objDeliverable.DeliverableId).ToList();
                            List<ClientTerritoryDTO> terList = new List<ClientTerritoryDTO>();
                            foreach (var o in tList)
                            {
                                ClientTerritoryDTO objTer = new ClientTerritoryDTO();
                                objTer.Id = o.territory.Id;
                                objTer.Name = GetTerritoryName(o.territory);// o.territory.Name;
                                objTer.TerritoryBase = (o.territory.IsBrickBased == true ? "Brick" : "Outlet");
                                terList.Add(objTer);
                            }

                            if (terList != null && terList.Count > 0)
                            {
                                terList = terList.OrderBy(t => t.Name).ToList();
                            }
                            DeliveryObj.territories = terList;
                            var cList = dbContext.DeliveryClients.Where(z => z.DeliverableId == objDeliverable.DeliverableId).ToList();
                            List<ClientDTO> clientList = new List<ClientDTO>();
                            foreach (var c in cList)
                            {
                                ClientDTO o = new ClientDTO();
                                o.Id = c.client.Id;
                                o.Name = c.client.Name;
                                o.IsThirdparty = false;
                                clientList.Add(o);
                            }
                            var tpartyList = dbContext.DeliveryThirdParties.Where(o => o.DeliverableId == objDeliverable.DeliverableId).ToList();
                            foreach (var c in tpartyList)
                            {
                                ClientDTO o = new ClientDTO();
                                o.Id = c.thirdParty.ThirdPartyId;
                                o.Name = c.thirdParty.Name;
                                o.IsThirdparty = true;
                                clientList.Add(o);
                            }
                            DeliveryObj.clients = clientList.OrderBy(p => p.Name).ToList();

                            DeliverablesDTOList.Add(DeliveryObj);
                        }
                    }


                }
                json = JsonConvert.SerializeObject(DeliverablesDTOList, Formatting.Indented,
                            new JsonSerializerSettings
                            {
                                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                            });

                return json;           
        }

        /// <summary>
        /// Download Deliverables by a client to be exported to excel
        /// </summary>
        /// <param name="clientid"></param>
        /// <returns></returns>
        [Route("api/deliverables/DownloadDeliverablesByClient")]
        [HttpGet]
        public HttpResponseMessage DownloadDeliverablesByClient(int clientid)
        {
            AuthController objAuth = new AuthController();
            if (objAuth.CheckUserClients(clientid) == 0)
                return new HttpResponseMessage(HttpStatusCode.NotFound); ;
            List<DeliverablesDTO> DeliverablesDTOList = new List<DeliverablesDTO>();
            var DeliverableList = dbContext.deliverables.Where(p => p.subscription.ClientId == clientid && p.subscription.EndDate.Year >= DateTime.Now.Year).ToList();
            string json = string.Empty;
            if (DeliverableList != null && DeliverableList.Count > 0)
            {
                foreach (var objDeliverable in DeliverableList)
                {
                    if (objDeliverable.subscription.Active == true)
                    {
                        DeliverablesDTO DeliveryObj = new DeliverablesDTO();
                        //foreach (var obj in objDeliverable)
                        //{
                        DeliveryObj.ClientId = objDeliverable.subscription.ClientId;
                        DeliveryObj.ClientName = objDeliverable.subscription.client.Name;
                        DeliveryObj.DeliverableId = objDeliverable.DeliverableId;
                        DeliveryObj.DisplayName = getSubscriptionName(objDeliverable);
                        var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                        var endDate = new DateTime(DateTime.Now.Year, 12, 1);
                        DeliveryObj.StartDate = objDeliverable.StartDate == null ? startDate : objDeliverable.StartDate;
                        DeliveryObj.EndDate = objDeliverable.EndDate == null ? endDate : objDeliverable.EndDate;
                        DeliveryObj.FrequencyTypeId = objDeliverable.FrequencyTypeId;
                        DeliveryObj.FrequencyId = (objDeliverable.FrequencyId == null ? 0 : objDeliverable.FrequencyId.Value);
                        DeliveryObj.FrequencyName = (objDeliverable.frequency == null ? "" : objDeliverable.frequency.Name);
                        DeliveryObj.LastModified = objDeliverable.LastModified;
                        DeliveryObj.ModifiedBy = objDeliverable.ModifiedBy;

                        DeliveryObj.PeriodId = objDeliverable.perioid.PeriodId;
                        DeliveryObj.PeriodName = objDeliverable.perioid.Name;
                        DeliveryObj.RestrictionId = (objDeliverable.RestrictionId == null ? 0 : objDeliverable.RestrictionId.Value);
                        List<string> lstRestriction = new List<string>();
                        if (objDeliverable.RestrictionId != null && objDeliverable.RestrictionId > 0)
                        {
                            var delTerList = dbContext.DeliveryTerritories.Where(p => p.DeliverableId == objDeliverable.DeliverableId).ToList();
                            foreach (var objT in delTerList)
                            {
                                lstRestriction.Add(objDeliverable.RestrictionId + "-" + objT.territory.Levels.SingleOrDefault(x => x.LevelNumber == objDeliverable.RestrictionId).Name);
                            }
                            var distRestriction = lstRestriction.Distinct();
                            DeliveryObj.RestrictionName = string.Join(", ", distRestriction);
                        }
                        else
                        {
                            DeliveryObj.RestrictionName = "N/A";
                        }

                        DeliveryObj.ReportWriterId = objDeliverable.ReportWriterId == null ? 0 : objDeliverable.ReportWriterId.Value;
                        DeliveryObj.ReportWriterName = objDeliverable.reportWriter == null ? "" : objDeliverable.reportWriter.Code + " " + objDeliverable.reportWriter.Name;

                        DeliveryObj.SubscriptionId = objDeliverable.SubscriptionId;
                        DeliveryObj.SubServiceTerritoryId = objDeliverable.subscription.ServiceTerritoryId;
                        //var locks = dbContext.LockHistories.Where(y => y.DocType == "Delivery" && y.DefId == objDeliverable.DeliverableId).ToList();
                        //if (locks == null || locks.Count == 0)
                        //{
                        //    DeliveryObj.LockType = "";
                        //}
                        //else
                        //{
                        //    if (locks.Count(z => z.LockType == "Edit") > 0)
                        //        DeliveryObj.LockType = "Edit";
                        //    else
                        //        DeliveryObj.LockType = "View";
                        //}
                        //var allocObj = dbContext.ClientRelease.SingleOrDefault(x => x.ClientId == objDeliverable.subscription.ClientId);
                        //if (allocObj == null)
                        //{
                        //    DeliveryObj.IsOneKeyAvailable = false;
                        //    DeliveryObj.IsCensusAvailable = false;
                        //    DeliveryObj.OneKey = null;
                        //    DeliveryObj.Census = null;
                        //}
                        //else
                        //{
                        //    if (allocObj.Census == true)
                        //    {
                        //        DeliveryObj.IsCensusAvailable = true;
                        //        DeliveryObj.Census = objDeliverable.Census == null ? true : objDeliverable.Census.Value;
                        //    }
                        //    else
                        //    {
                        //        DeliveryObj.IsCensusAvailable = false;
                        //        DeliveryObj.Census = null;
                        //    }
                        //    if (allocObj.OneKey == true)
                        //    {
                        //        DeliveryObj.IsOneKeyAvailable = true;
                        //        DeliveryObj.OneKey = objDeliverable.OneKey == null ? true : objDeliverable.OneKey.Value;
                        //    }
                        //    else
                        //    {
                        //        DeliveryObj.IsOneKeyAvailable = false;
                        //        DeliveryObj.OneKey = null;
                        //    }
                        //}
                        //int ProbCount = dbContext.ClientMFR.Count(y => y.ClientId == objDeliverable.subscription.ClientId);
                        //int PackCount = dbContext.ClientPackException.Count(z => z.ClientId == objDeliverable.subscription.ClientId);
                        //if (ProbCount > 0)
                        //{
                        //    DeliveryObj.IsProbeAvailable = true;
                        //    DeliveryObj.probe = objDeliverable.probe == null ? true : objDeliverable.probe.Value;
                        //}
                        //else
                        //{
                        //    DeliveryObj.IsProbeAvailable = false;
                        //    DeliveryObj.probe = false;
                        //}
                        //if (PackCount > 0)
                        //{
                        //    DeliveryObj.IsPackExcAvailable = true;
                        //    DeliveryObj.PackException = objDeliverable.PackException == null ? true : objDeliverable.PackException.Value;
                        //}
                        //else
                        //{
                        //    DeliveryObj.IsPackExcAvailable = false;
                        //    DeliveryObj.PackException = null;
                        //}

                        DeliveryObj.OneKey = objDeliverable.OneKey == null ? false : objDeliverable.OneKey.Value;
                        DeliveryObj.PackException = objDeliverable.PackException == null ? false : objDeliverable.PackException.Value;
                        DeliveryObj.probe = objDeliverable.probe == null ? false : objDeliverable.probe.Value;
                        DeliveryObj.Census = objDeliverable.Census == null ? false : objDeliverable.Census.Value;
                        DeliveryObj.IsOneKeyAvailable = objDeliverable.OneKey == null || objDeliverable.OneKey.Value == false ? false : true;
                        DeliveryObj.IsPackExcAvailable = objDeliverable.PackException == null || objDeliverable.PackException.Value == false ? false : true;
                        DeliveryObj.IsProbeAvailable = objDeliverable.probe == null || objDeliverable.probe.Value == false ? false : true;
                        DeliveryObj.IsCensusAvailable = objDeliverable.Census == null || objDeliverable.Census.Value == false ? false : true;



                        var mktlst = dbContext.DeliveryMarkets.Where(x => x.DeliverableId == objDeliverable.DeliverableId).ToList();
                        List<ClientMarketDefDTO> mktList = new List<ClientMarketDefDTO>();

                        foreach (var oMkt in mktlst)
                        {

                            ClientMarketDefDTO mktObj = new ClientMarketDefDTO();
                            if (oMkt != null)
                            {
                                mktObj.Id = oMkt.marketDefinition.Id;
                                mktObj.Name = oMkt.marketDefinition.Name;
                                //foreach (var o in oMkt.marketDefinition)
                                //{

                                List<MarketBaseDTO> lstMktBase = new List<MarketBaseDTO>();
                                foreach (var m in oMkt.marketDefinition.MarketDefinitionBaseMaps)
                                {
                                    MarketBaseDTO mktBase = new MarketBaseDTO();
                                    mktBase.Id = m.MarketBase.Id;
                                    mktBase.Name = m.MarketBase.Name + " " + m.MarketBase.Suffix;
                                    mktBase.Description = m.MarketBase.Description;
                                    mktBase.DurationFrom = m.MarketBase.DurationFrom;
                                    mktBase.DurationTo = m.MarketBase.DurationTo;
                                    lstMktBase.Add(mktBase);
                                }
                                mktObj.marketBaseDTOs = lstMktBase;
                                //}

                                mktList.Add(mktObj);
                            }
                        }
                        DeliveryObj.marketDefs = mktList;
                        var tList = dbContext.DeliveryTerritories.Where(y => y.DeliverableId == objDeliverable.DeliverableId).ToList();
                        List<ClientTerritoryDTO> terList = new List<ClientTerritoryDTO>();
                        foreach (var o in tList)
                        {
                            ClientTerritoryDTO objTer = new ClientTerritoryDTO();
                            objTer.Id = o.territory.Id;
                            objTer.Name = GetTerritoryName(o.territory);// o.territory.Name;
                            objTer.TerritoryBase = (o.territory.IsBrickBased == true ? "Brick" : "Outlet");
                            terList.Add(objTer);
                        }
                        DeliveryObj.territories = terList;
                        var cList = dbContext.DeliveryClients.Where(z => z.DeliverableId == objDeliverable.DeliverableId).ToList();
                        List<ClientDTO> clientList = new List<ClientDTO>();
                        foreach (var c in cList)
                        {
                            ClientDTO o = new ClientDTO();
                            o.Id = c.client.Id;
                            o.Name = c.client.Name;
                            o.IsThirdparty = false;
                            clientList.Add(o);
                        }
                        var tpartyList = dbContext.DeliveryThirdParties.Where(o => o.DeliverableId == objDeliverable.DeliverableId).ToList();
                        foreach (var c in tpartyList)
                        {
                            ClientDTO o = new ClientDTO();
                            o.Id = c.thirdParty.ThirdPartyId;
                            o.Name = c.thirdParty.Name;
                            o.IsThirdparty = true;
                            clientList.Add(o);
                        }
                        DeliveryObj.clients = clientList.OrderBy(p => p.Name).ToList();

                        DeliverablesDTOList.Add(DeliveryObj);
                    }
                }


            }
            DataTable delvDT = BuildDeliverablesDataTable(DeliverablesDTOList);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
            MemoryStream stream = new MemoryStream();

            stream = GetExcelStream(delvDT);
            // Reset Stream Position
            stream.Position = 0;
            result.Content = new StreamContent(stream);

            // Generic Content Header
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            return result;
            //json = JsonConvert.SerializeObject(DeliverablesDTOList, Formatting.Indented,
            //            new JsonSerializerSettings
            //            {
            //                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            //            });

            //return json;
        }

        /// <summary>
        /// Get the excel stream  to store the data in excel format
        /// </summary>
        /// <param name="list1"></param>
        /// <returns></returns>
        public static MemoryStream GetExcelStream(DataTable list1)
        {
            ExcelPackage pck = new ExcelPackage();

            // get the handle to the existing worksheet
            var wsData = pck.Workbook.Worksheets.Add("Deliverables Details");
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

        /// <summary>
        /// Build data table for deliverables to be downloaded in excel sheet
        /// </summary>
        /// <param name="DeliverableList"></param>
        /// <returns></returns>
        private DataTable BuildDeliverablesDataTable(List<DeliverablesDTO> DeliverableList)
        {
            DataTable Dt = new DataTable();

            Dt.Columns.Add(new DataColumn("ClientId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("ClientName", typeof(String)));
            Dt.Columns.Add(new DataColumn("DeliverableId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("DisplayName", typeof(String)));
            Dt.Columns.Add(new DataColumn("SubscriptionId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("ReportWriterId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("ReportWriterName", typeof(String)));
            Dt.Columns.Add(new DataColumn("FrequencyTypeId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("RestrictionId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("RestrictionName", typeof(String)));
            Dt.Columns.Add(new DataColumn("PeriodId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("PeriodName", typeof(String)));
            Dt.Columns.Add(new DataColumn("FrequencyId", typeof(Int32)));
            Dt.Columns.Add(new DataColumn("FrequencyName", typeof(String)));
            Dt.Columns.Add(new DataColumn("StartDate", typeof(DateTime)));
            Dt.Columns.Add(new DataColumn("EndDate", typeof(DateTime)));
            Dt.Columns.Add(new DataColumn("probe", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("PackException", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("Census", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("OneKey", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("IsProbeAvailable", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("IsPackExcAvailable", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("IsCensusAvailable", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("IsOneKeyAvailable", typeof(Boolean)));
            Dt.Columns.Add(new DataColumn("LastModified", typeof(DateTime)));
            Dt.Columns.Add(new DataColumn("ModifiedBy", typeof(String)));
            Dt.Columns.Add(new DataColumn("SubServiceTerritoryId", typeof(Int32)));
            //public List<ClientMarketDefDTO> marketDefs { get; set; }
            //public List<ClientTerritoryDTO> territories { get; set; }
            //public List<ClientDTO> clients { get; set; }
            //public string LockType { get; set; }

            foreach (DeliverablesDTO delv in DeliverableList)
            {
                ////if (delv.MarketBase != null && delv.MarketBase.Count > 0)
                ////{
                ////    foreach (MarketBase mkb in delv.MarketBase)
                ////    {
                ////        DataRow dr = Dt.NewRow();
                ////        dr["clientId"] = delv.ClientId;
                ////        dr["clientName"] = delv.ClientName;
                ////        dr["subscriptionId"] = delv.subscription.SubscriptionId;

                ////        dr["Name"] = delv.subscription.Name;
                ////        dr["CountryId"] = delv.subscription.CountryId;
                ////        dr["ServiceId"] = delv.subscription.ServiceId;
                ////        dr["DataTypeId"] = delv.subscription.DataTypeId;
                ////        dr["Country"] = delv.subscription.Country;
                ////        dr["Service"] = delv.subscription.Service;

                ////        dr["Data"] = delv.subscription.Data;
                ////        dr["source"] = delv.subscription.Source;
                ////        dr["ServiceTerritoryId"] = delv.subscription.ServiceTerritoryId;
                ////        dr["MarketBaseId"] = mkb.Id;
                ////        dr["MarketBaseName"] = mkb.Name;
                ////        dr["MarketBaseDescription"] = mkb.Description;
                ////        dr["DurationFrom"] = mkb.DurationFrom;
                ////        dr["DurationTo"] = mkb.DurationTo;
                ////        Dt.Rows.Add(dr);
                ////    }
                //}
                //else
                //{
                DataRow dr = Dt.NewRow();
                dr["clientId"] = delv.ClientId;
                dr["clientName"] = delv.ClientName;
                dr["DeliverableId"] = delv.DeliverableId;
                dr["DisplayName"] = delv.DisplayName;
                dr["SubscriptionId"] = delv.SubscriptionId;
                dr["ReportWriterId"] = delv.ReportWriterId;
                dr["ReportWriterName"] = delv.ReportWriterName;
                dr["FrequencyTypeId"] = delv.FrequencyTypeId;
                dr["RestrictionId"] = delv.RestrictionId;
                dr["RestrictionName"] = delv.RestrictionName;
                dr["PeriodId"] = delv.PeriodId;
                dr["PeriodName"] = delv.PeriodName;
                dr["FrequencyId"] = delv.FrequencyId;
                dr["FrequencyName"] = delv.FrequencyName;
                dr["StartDate"] = delv.StartDate;
                dr["EndDate"] = delv.EndDate;
                dr["probe"] = delv.probe;
                dr["PackException"] = delv.PackException;
                dr["Census"] = delv.Census;
                dr["OneKey"] = delv.OneKey;
                dr["IsProbeAvailable"] = delv.IsProbeAvailable;
                dr["IsPackExcAvailable"] = delv.IsPackExcAvailable;
                dr["IsCensusAvailable"] = delv.IsCensusAvailable;
                dr["IsOneKeyAvailable"] = delv.IsOneKeyAvailable;
                dr["LastModified"] = delv.LastModified;
                dr["ModifiedBy"] = delv.ModifiedBy;
                dr["SubServiceTerritoryId"] = delv.SubServiceTerritoryId;
                Dt.Rows.Add(dr);
                // }

            }





            return Dt;
        }

        /// <summary>
        /// Clone the Deliverables
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/deliverables/CloneDeliverable")]
        [HttpPost]
        public HttpResponseMessage CloneDeliverable([FromBody]JObject request)
        {
            if (request != null)
            {
                int clientID = 0;
                if (request["clientid"] != null)
                {
                    string clientid = request["clientid"].ToString();
                    int.TryParse(clientid, out clientID);
                }
                AuthController objAuth = new AuthController();
                if (objAuth.CheckUserClients(clientID) == 0)
                    return Request.CreateResponse(HttpStatusCode.NoContent);

                string userid = request["userid"].ToString();
                var delIds = request["deliverableid"].ToList();
                int uid = 1;
                int.TryParse(userid, out uid);

                int deliverableId;
                int newDeliverableId = 0;
                Deliverables delObj;
                for (int i = 0; i < delIds.Count; i++)
                {
                    deliverableId = 0;
                    int.TryParse(delIds[i].ToString(), out deliverableId);
                    using (var transaction = dbContext.Database.BeginTransaction())
                    {
                        delObj = new Deliverables();
                        var delDBObj = dbContext.deliverables.SingleOrDefault(p => p.DeliverableId == deliverableId);
                        if (delDBObj != null)
                        {
                            delObj = Clone(delDBObj) as Deliverables;
                            delObj.DeliverableId = -1;
                            delObj.ModifiedBy = uid;
                            delObj.LastModified = DateTime.Now;
                            dbContext.deliverables.Add(delObj);
                            dbContext.SaveChanges();
                            newDeliverableId = delObj.DeliverableId;
                        }
                        var delDBMkt = dbContext.DeliveryMarkets.Where(a => a.DeliverableId == deliverableId).ToList();
                        foreach (var obj in delDBMkt)
                        {
                            DeliveryMarket delMkt = new DeliveryMarket();
                            delMkt.DeliveryMarketId = -1;
                            delMkt.DeliverableId = newDeliverableId;
                            delMkt.MarketDefId = obj.MarketDefId;
                            dbContext.DeliveryMarkets.Add(delMkt);
                            dbContext.SaveChanges();
                        }
                        var delDBTerr = dbContext.DeliveryTerritories.Where(a => a.DeliverableId == deliverableId).ToList();
                        foreach (var obj in delDBTerr)
                        {
                            DeliveryTerritory delTer = new DeliveryTerritory();
                            delTer.DeliveryTerritoryId = -1;
                            delTer.DeliverableId = newDeliverableId;
                            delTer.TerritoryId = obj.TerritoryId;
                            dbContext.DeliveryTerritories.Add(delTer);
                            dbContext.SaveChanges();
                        }
                        var delDBClnt = dbContext.DeliveryClients.Where(a => a.DeliverableId == deliverableId).ToList();
                        foreach (var obj in delDBClnt)
                        {
                            DeliveryClient delClnt = new DeliveryClient();
                            delClnt.DeliveryClientId = -1;
                            delClnt.DeliverableId = newDeliverableId;
                            delClnt.ClientId = obj.ClientId;
                            dbContext.DeliveryClients.Add(delClnt);
                            dbContext.SaveChanges();
                        }
                        transaction.Commit();
                    }

                }
            }
            return Request.CreateResponse(HttpStatusCode.Created);

        }
        public static object Clone(object obj)
        {
            object new_obj = Activator.CreateInstance(obj.GetType());
            foreach (PropertyInfo pi in obj.GetType().GetProperties())
            {
                if (pi.CanRead && pi.CanWrite && pi.PropertyType.IsSerializable)
                {
                    pi.SetValue(new_obj, pi.GetValue(obj, null), null);
                }
            }
            return new_obj;
        }
        //private List<Frequency> GetFrequncyList(string freqType)
        //{
        //    List<Frequency> freqList = new List<Frequency>();
        //    //Frequency freqObj = new freqObj();
        //    switch (freqType.ToLower())
        //    {
        //        case "monthly":
        //            {
        //                freqList.Add(new Frequency { Id = 1, Value = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" });
        //                break;
        //            }
        //        case "quarterly":
        //            {
        //                freqList.Add(new Frequency { Id = 1, Value = "Jan,Apr,Jul,Oct" });
        //                freqList.Add(new Frequency { Id = 2, Value = "Feb,May,Aug,Nov" });
        //                freqList.Add(new Frequency { Id = 3, Value = "Mar,Jun,Sep,Dec" });
        //                break;
        //            }
        //        case "timester":
        //            {
        //                freqList.Add(new Frequency { Id = 1, Value = "Jan,May,Sep" });
        //                freqList.Add(new Frequency { Id = 2, Value = "Feb,Jun,Oct" });
        //                freqList.Add(new Frequency { Id = 3, Value = "Mar,Jul,Nov" });
        //                freqList.Add(new Frequency { Id = 4, Value = "Apr,Aug,Dec" });
        //                break;
        //            }
        //        case "bi-annual":
        //            {
        //                freqList.Add(new Frequency { Id = 1, Value = "Jan,Jul" });
        //                freqList.Add(new Frequency { Id = 2, Value = "Feb,Aug" });
        //                freqList.Add(new Frequency { Id = 3, Value = "Mar,Sep" });
        //                freqList.Add(new Frequency { Id = 4, Value = "Apr,Oct" });
        //                freqList.Add(new Frequency { Id = 5, Value = "May,Nov" });
        //                freqList.Add(new Frequency { Id = 6, Value = "Jun,Dec" });

        //                break;
        //            }
        //        case "annual":
        //            {
        //                string[] names = DateTimeFormatInfo.CurrentInfo.MonthNames;
        //                for (int i = 0; i < 12; i++)
        //                {
        //                    freqList.Add(new Frequency { Id = i+1, Value = CultureInfo.CurrentUICulture.DateTimeFormat.MonthNames[i] }); 
        //                }
        //                break;
        //            }
        //        case "weekly":
        //            {
        //                freqList.Add(new Frequency { Id = 1, Value = "52 Weeks" });
        //                freqList.Add(new Frequency { Id = 2, Value = "104 Weeks" });
        //                break;
        //            }

        //    }

        //    return freqList;
        //}

        private string GetTerritoryName(Territory o)
        {
            return o.SRA_Client == null ? o.Name : o.Name + " (" + o.SRA_Client + "" + o.SRA_Suffix + ")";
        }

        /// <summary>
        /// Acquire Lock for Editing 
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/deliverables/AddLock")]
        [HttpPost]
        public HttpResponseMessage AddLock([FromBody]JObject request)
        {
            HttpResponseMessage res;
            if (request != null)
            {
                LockHistory lkObj = new LockHistory();
                int defId, userId; string docType, lockType;
                defId = userId = 0;
                int.TryParse(request["defId"].ToString(), out defId);
                docType = request["docType"].ToString();
                lockType = request["lockType"].ToString();
                int.TryParse(request["userId"].ToString(), out userId);
                lkObj.DefId = defId;
                lkObj.DocType = docType;
                lkObj.LockType = lockType;
                lkObj.UserId = userId;
                lkObj.LockTime = DateTime.Now;

                dbContext.LockHistories.Add(lkObj);
                dbContext.SaveChanges();
                res = Request.CreateResponse(HttpStatusCode.Created);
            }
            else
            {
                res = Request.CreateResponse(HttpStatusCode.BadRequest);
            }
            return res;
        }

        /// <summary>
        ///  Release the lock acquired fro Deliverable Edit
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [Route("api/deliverables/ReleaseLock")]
        [HttpPost]
        public HttpResponseMessage ReleaseLock([FromBody]JObject request)
        {
            HttpResponseMessage res;
            if (request != null)
            {
                int defId, userId; string docType, lockType;
                defId = userId = 0;
                int.TryParse(request["defId"].ToString(), out defId);
                docType = request["docType"].ToString();
                lockType = request["lockType"].ToString();
                int.TryParse(request["userId"].ToString(), out userId);

                List<LockHistory> lstlock = new List<LockHistory>();
                if (defId > 0 && docType != "" && lockType != "")
                    lstlock = dbContext.LockHistories.Where(p => p.DefId == defId && p.UserId == userId && p.DocType == docType && p.LockType == lockType).ToList();
                else if (defId > 0 && docType != "")
                    lstlock = dbContext.LockHistories.Where(p => p.DefId == defId && p.UserId == userId && p.DocType == docType).ToList();
                else if (docType != "")
                    lstlock = dbContext.LockHistories.Where(p => p.UserId == userId && p.DocType == docType).ToList();
                else
                    lstlock = dbContext.LockHistories.Where(p => p.UserId == userId).ToList();

                dbContext.LockHistories.RemoveRange(lstlock);
                dbContext.SaveChanges();
                res = Request.CreateResponse(HttpStatusCode.Created);
            }
            else
            {
                res = Request.CreateResponse(HttpStatusCode.BadRequest);
            }
            return res;
        }
        /// <summary>
        /// Check the Delivery Type
        /// </summary>
        /// <param name="defId"></param>
        /// <returns>message for Lock/UnLock</returns>
        [Route("api/deliverables/CheckDeliveryLock")]
        [HttpGet]
        public string CheckDeliveryLock(int defId)
        {
            string msg = "";
            var obj = dbContext.LockHistories.SingleOrDefault(p => p.DefId == defId && p.DocType == "Delivery");
            if (obj != null)
            {
                if (obj.LockType == "Edit")
                    msg = "The definition is currently being edited by another user [" + obj.user.FirstName + " " + obj.user.LastName + "], hence cannot be edited, please try later.";
                else
                    msg = "The definition is currently being viewed by another user, hence cannot be deleted. Please try later.";
            }
            return msg;
        }

        [Route("api/deliverables/SubmitDeliverable")]
        [HttpPost]
        public HttpResponseMessage SubmitDeliverable(int[] DeliverableIds, int UserId)

        {
            foreach (int DeliverableId in DeliverableIds)
            {
                var objClient = dbContext.deliverables.Where(u => u.DeliverableId == DeliverableId).ToList().FirstOrDefault();
                IAuditLog log = AuditFactory.GetInstance(typeof(Deliverables).Name);
                log.SaveVersion<Deliverables>(objClient, UserId);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        public int? getIRPReportNo(int deliverableId)
        {
            using (EverestPortalContext context = new EverestPortalContext())
            {
                var reportNoEntry = (from d in context.DeliveryReports
                                     where d.DeliverableId == deliverableId && d.ReportNo != null
                                     select d).ToList();

                if (reportNoEntry != null && reportNoEntry.Count > 0) return reportNoEntry[0].ReportNo;
                else return null;
            }
        }

        public List<SubChannelsDTO> GetSubchannels(int deliverableId)
        {
            List<SubChannelsDTO> result = new List<SubChannelsDTO>();

            var subchannels = dbContext.EntityTypes
                .Join(dbContext.DataTypes,
                r => r.DataTypeId,
                d => d.DataTypeId,
                (r, d) => new { EntityTypes = r, DataTypes = d })
                .Where(r => r.DataTypes.IsChannel == true && r.EntityTypes.IsActive == true)
                .ToList();

            var deliverables = dbContext.SubChannels
                .Where(s => s.DeliverableId == deliverableId)
                .Select(s => s.EntityTypeId).ToList();

            var preferences = new List<string> { "retail", "hospital", "other outlet" };

            result = subchannels.GroupBy(r => r.DataTypes)
                .Select(r => new SubChannelsDTO
                {
                    DataType = new DataType { DataTypeId = r.Key.DataTypeId, Name = r.Key.Name },
                    EntityTypes = r.Select(x => new EntityType
                    {
                        EntityTypeId = x.EntityTypes.EntityTypeId,
                        EntityTypeCode = x.EntityTypes.EntityTypeCode,
                        EntityTypeName = x.EntityTypes.EntityTypeName,
                        DataTypeId = x.EntityTypes.DataTypeId,
                        Abbrev = x.EntityTypes.Abbrev,
                        Display = x.EntityTypes.Display,
                        IsSelected = deliverables.Contains(x.EntityTypes.EntityTypeId) ? true : false
                    }).OrderBy(e => e.EntityTypeName).ToList()
                }).OrderBy(o => {
                    var index = preferences.IndexOf(o.DataType.Name.ToLower());
                    return index == -1 ? int.MaxValue : index;
                }).ToList();

            return result;
        }
    }
}

