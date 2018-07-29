using IMS.EverestPortal.API.DAL;
using System.Collections.Generic;
using System.Linq;
using IMS.EverestPortal.API.Models;
using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace IMS.EverestPortal.API.AuditReport
{

    public class DeliverableReport : IAuditReport
    {
        private EverestPortalContext _db = new EverestPortalContext();
        string ConnectionString = "EverestPortalConnection";
        public dynamic GenerateReport(int Id, int startversion, int endVersion, string report)
        {
            List<string> nameChangeParm = new List<string>() { "PeriodId", "FrequencyId", "FrequencyTypeId",  "ReportWriterId", "RestrictionId" ,"DeliveredTo", "Census", "PackException", "OneKey" , "probe" };
            DeliverablesDTO dto = new DeliverablesDTO();

            List<Deliverables_History> result = _db.Deliverables_History.Where(i => i.DeliverableId == Id).Where(x => x.Version >= startversion && x.Version <= endVersion).ToList();

            #region Deliverable Report Parameter Change
            if (report == ReportRequestType.DeliverableReportParameterChange)
            {
                if (result.Count > 1)
                {
                    dto.DeliverableReportParameterChange = new List<DeliverableReportParameterChangeDTO>();
                    for (int i = 1; i < result.Count; i++)
                    {
                        var item1 = result[i - 1];
                        var item2 = result[i];
                        var diffList = item1.GetObjectDifference(item2, nameChangeParm);
                        DateTime r = DateTime.MinValue;
                        DeliverableReportParameterChangeDTO diff = new DeliverableReportParameterChangeDTO();
                        if (diffList.Count >= 1   || IsdeliveredToChanged(Id,item1.Version, item2.Version))
                        {
                            if (item1 != null)
                            {
                                if ((item1.StartDate != null && DateTime.TryParse(item1.StartDate.ToString(), out r)) && (item1.EndDate != null && DateTime.TryParse(item1.EndDate.ToString(), out r)))
                                    diff.DataDeliveryPeriod = item1.StartDate.ToString("MMM-yyyy") + "~" + item1.EndDate.ToString("MMM-yyyy");
                                diff.VersionNumber = item1.Version;
                                var userDetail = _db.Users.Where(a => a.UserID == item1.UserId).FirstOrDefault();
                                if (userDetail != null)
                                {
                                    diff.SubmittedBy = (!string.IsNullOrEmpty( userDetail.FirstName) ? userDetail.FirstName :string.Empty )+ " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty);
                                }
                                if (item1.ModifiedDate != null && DateTime.TryParse(item1.ModifiedDate.ToString(), out r))
                                {
                                    diff.DateTime = item1.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss"); 
                                        //("dd/MM/yyyy HH:mm:ss");
                                }
                                if (item1.FrequencyId != null && item1.FrequencyId != 0)
                                {
                                    diff.Frequency = _db.Frequencies.Where(m => m.FrequencyId == (int)item1.FrequencyId).FirstOrDefault().Name.ToString();
                                }
                                if (item1.PeriodId != 0)
                                {
                                    diff.Period = _db.Periods.Where(m => m.PeriodId == (int)item1.PeriodId).FirstOrDefault().Name.ToString();
                                }
                                if (item1.ReportWriterId != null && item1.ReportWriterId != 0)
                                {
                                    diff.ReportWriter = _db.ReportWriters.Where(m => m.ReportWriterId == (int)item1.ReportWriterId).FirstOrDefault().Code.ToString();
                                    diff.ReportWriter += " " + _db.ReportWriters.Where(m => m.ReportWriterId == (int)item1.ReportWriterId).FirstOrDefault().Name.ToString();
                                }
                                if (item1.RestrictionId != null && item1.RestrictionId != 0)
                                {
                                   // diff.Restriction =!(string.IsNullOrEmpty(_db.Levels.Where(m => m.LevelNumber == (int)item1.RestrictionId).FirstOrDefault().Name.ToString())) ? _db.Levels.Where(m => m.LevelNumber == (int)item1.RestrictionId).FirstOrDefault().Name.ToString() : string.Empty;
                                    diff.Restriction = GetRestrictionNames(Id, item1.RestrictionId);
                                }
                                diff.Census = (item1.Census == false )? "False" : "True";
                                diff.One_Key = (item1.OneKey == false )? "False" : "True";
                                diff.PackException = (item1.PackException == false )? "False" : "True";
                                diff.PROBE = (item1.probe == false )? "False" : "True";
                                List<int> ClientIDs = _db.DeliveryClient_History.Where(d => d.DeliverableId == Id && d.DeliverableVersion == item2.Version).Select(d1 => d1.ClientId).ToList();
                                List<int> ThirdPartyIDs = _db.DeliveryThirdParty_History.Where(d => d.DeliverableId == Id && d.DeliverableVersion == item2.Version).Select(d1 => d1.ThirdPartyId).ToList();
                                string ClientNames = string.Join(",", _db.Clients.Where(cl => ClientIDs.Contains(cl.Id)).Select(c => c.Name).ToList());
                                string ThirdParties = string.Join(",", _db.ThirdParties.Where(cl => ThirdPartyIDs.Contains(cl.ThirdPartyId)).Select(c => c.Name).ToList());
                                if (!string.IsNullOrEmpty(ClientNames) && !string.IsNullOrEmpty(ThirdParties))
                                {
                                    diff.DeliveredTo = string.Concat(ClientNames, ",", ThirdParties);
                                }
                                else if (string.IsNullOrEmpty(ThirdParties))
                                {
                                    diff.DeliveredTo = ClientNames;
                                }
                                else
                                {
                                    diff.DeliveredTo = ThirdParties;
                                }
                            }
                            if (dto == null)
                                dto = new DeliverablesDTO();
                            int iCnt = dto.DeliverableReportParameterChange.Where(a => a.VersionNumber == item1.Version).Count();
                            if (iCnt == 0)
                            {
                                dto.DeliverableReportParameterChange.Add(diff);
                            }
                            if (item2 != null)
                            {
                                diff = new DeliverableReportParameterChangeDTO();
                                if ((item2.StartDate != null && DateTime.TryParse(item2.StartDate.ToString(), out r)) && (item2.EndDate != null && DateTime.TryParse(item2.EndDate.ToString(), out r)))
                                    diff.DataDeliveryPeriod = item2.StartDate.ToString("MMM-yyyy") + "~" + item2.EndDate.ToString("MMM-yyyy");
                                diff.VersionNumber = item2.Version;
                                var userDetail = _db.Users.Where(a => a.UserID == item2.UserId).FirstOrDefault();
                                if (userDetail != null)
                                {
                                    diff.SubmittedBy = (!string.IsNullOrEmpty(userDetail.FirstName) ? userDetail.FirstName : string.Empty) + " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty);
                                }
                                if (item2.ModifiedDate != null && DateTime.TryParse(item2.ModifiedDate.ToString(), out r))
                                {
                                    diff.DateTime = item2.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                                        //("dd/MM/yyyy HH:mm:ss");
                                }
                                if (item2.FrequencyId != null && item2.FrequencyId != 0)
                                {
                                    diff.Frequency = _db.Frequencies.Where(m => m.FrequencyId == (int)item2.FrequencyId).FirstOrDefault().Name.ToString();
                                }
                                if (item2.PeriodId > 0)
                                {
                                    diff.Period = _db.Periods.Where(m => m.PeriodId == (int)item2.PeriodId).FirstOrDefault().Name.ToString();
                                }
                                if (item2.ReportWriterId != null && item2.ReportWriterId != 0)
                                {
                                    diff.ReportWriter = _db.ReportWriters.Where(m => m.ReportWriterId == (int)item2.ReportWriterId).FirstOrDefault().Code.ToString();
                                    diff.ReportWriter += " " + _db.ReportWriters.Where(m => m.ReportWriterId == (int)item2.ReportWriterId).FirstOrDefault().Name.ToString();
                                }
                                if (item2.RestrictionId!=null && item2.RestrictionId != 0)
                                {
                                    //diff.Restriction = (!string.IsNullOrEmpty(_db.Levels.Where(m => m.LevelNumber == (int)item2.RestrictionId).FirstOrDefault().Name.ToString())) ? _db.Levels.Where(m => m.LevelNumber == (int)item2.RestrictionId).FirstOrDefault().Name.ToString() : string.Empty;
                                    diff.Restriction = GetRestrictionNames(Id, item2.RestrictionId);
                                }
                                diff.Census = (item2.Census == false )? "False" : "True";
                                diff.One_Key= (item2.OneKey == false )? "False" : "True";
                                diff.PackException = (item2.PackException == false )? "False" : "True";
                                diff.PROBE = (item2.probe == false )? "False" : "True";
                                List<int> ClientIDs = _db.DeliveryClient_History.Where(d => d.DeliverableId == Id && d.DeliverableVersion == item2.Version).Select(d1 => d1.ClientId).ToList();
                                List<int> ThirdPartyIDs = _db.DeliveryThirdParty_History.Where(d => d.DeliverableId == Id && d.DeliverableVersion == item2.Version).Select(d1 => d1.ThirdPartyId).ToList();

                                string ClientNames = string.Join(",", _db.Clients.Where(cl => ClientIDs.Contains(cl.Id)).Select(c => c.Name).ToList());
                                string ThirdParties = string.Join(",", _db.ThirdParties.Where(cl => ThirdPartyIDs.Contains(cl.ThirdPartyId)).Select(c => c.Name).ToList());
                                if (!string.IsNullOrEmpty(ClientNames) && !string.IsNullOrEmpty(ThirdParties))
                                {
                                    diff.DeliveredTo = string.Concat(ClientNames, ",", ThirdParties);
                                }
                                else if (string.IsNullOrEmpty(ThirdParties))
                                {
                                    diff.DeliveredTo = ClientNames;
                                }
                                else
                                {
                                    diff.DeliveredTo = ThirdParties;
                                }
                                dto.DeliverableReportParameterChange.Add(diff);
                            }
                        }
                    }
                }
            }
            #endregion

            #region Deliverable Mkt Defn Change

            if (report == ReportRequestType.DeliverableMktDfnChange)
            {

                DeliverableMktDfnDTO delMktDto = new DeliverableMktDfnDTO();
                List<DeliverableMktDfnDTO> lstDelMktDto = new List<DeliverableMktDfnDTO>();
                dto.DeliverableMktDfnChange = new List<DeliverableMktDfnDTO>();
                var MarketDefinitions = (from delMkt in _db.DeliveryMarket_History
                                         where delMkt.DeliverableId == Id && delMkt.DeliverableVersion >= startversion && delMkt.DeliverableVersion <= endVersion
                                         select new
                                         {
                                             delMkt.MarketDefVersion,
                                             delMkt.DeliverableId,
                                             delMkt.MarketDefId,
                                             delMkt.DeliverableVersion
                                         }).Distinct().ToList();

                for (int version = startversion; version < endVersion; version++)
                {
                    var tempList1 = MarketDefinitions.Where(x => x.DeliverableVersion == version).ToList();
                    var tempList2 = MarketDefinitions.Where(x => x.DeliverableVersion == version + 1).ToList();
                    var deletedItem = tempList1.Where(a => !tempList2.Any(a1 => a1.MarketDefId == a.MarketDefId)).Distinct().ToList(); 
                    var insertedItem = tempList2.Where(a => !tempList1.Any(a1 => a1.MarketDefId == a.MarketDefId)).Distinct().ToList(); 

                        if (dto == null)
                            dto = new DeliverablesDTO();
                    DateTime dtModifiedDate = DateTime.MinValue;
                    foreach (var mkt in deletedItem)
                        {
                            delMktDto = new DeliverableMktDfnDTO();
                        if (_db.MarketDefinitions.Where(x => x.Id == mkt.MarketDefId).FirstOrDefault() != null)
                        {
                            delMktDto.MarketDefinitionName += _db.MarketDefinitions.Where(x => x.Id == mkt.MarketDefId).FirstOrDefault().Name;
                        }
                        else if (_db.MarketDefinitions_History.Where(x => x.MarketDefId == mkt.MarketDefId).FirstOrDefault() != null)
                        {
                            delMktDto.MarketDefinitionName += _db.MarketDefinitions_History.Where(x => x.MarketDefId == mkt.MarketDefId).OrderByDescending(y => y.ModifiedDate).FirstOrDefault().Name;
                        }
                            delMktDto.MarketDefnitionVersion = mkt.MarketDefVersion;
                            delMktDto.VersionNumber = version + 1;
                            delMktDto.Action = "Deleted";
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault() != null)
                        {
                            dtModifiedDate = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault().ModifiedDate;
                        }
                        int userId = 0;
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault() != null)
                        {
                             userId = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault().UserId;
                        }
                        var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                        if (userDetail != null)
                        {
                            delMktDto.SubmittedBy = (!string.IsNullOrEmpty(userDetail.FirstName) ? userDetail.FirstName : string.Empty) + " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty);
                        }
                        delMktDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            dto.DeliverableMktDfnChange.Add(delMktDto);
                        }
                        foreach (var mkt in insertedItem)
                        {
                            delMktDto = new DeliverableMktDfnDTO();
                        if (_db.MarketDefinitions.Where(x => x.Id == mkt.MarketDefId).FirstOrDefault() != null)
                        {
                            delMktDto.MarketDefinitionName += _db.MarketDefinitions.Where(x => x.Id == mkt.MarketDefId).FirstOrDefault().Name;
                        }
                        else if (_db.MarketDefinitions_History.Where(x => x.MarketDefId == mkt.MarketDefId).FirstOrDefault() != null)
                        {
                            delMktDto.MarketDefinitionName += _db.MarketDefinitions_History.Where(x => x.MarketDefId == mkt.MarketDefId ).OrderByDescending(y => y.ModifiedDate).FirstOrDefault().Name;
                        }
                        delMktDto.MarketDefnitionVersion = mkt.MarketDefVersion;
                            delMktDto.VersionNumber = mkt.DeliverableVersion;
                            delMktDto.Action = "Added";
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault() != null)
                        {
                            dtModifiedDate = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delMktDto.VersionNumber).FirstOrDefault().ModifiedDate;
                        }
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == mkt.DeliverableVersion).FirstOrDefault() != null)
                        {
                            int userId = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == mkt.DeliverableVersion).FirstOrDefault().UserId;
                            var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                            if (userDetail != null)
                            {
                                delMktDto.SubmittedBy = (!string.IsNullOrEmpty(userDetail.FirstName) ? userDetail.FirstName : string.Empty) + " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty);
                            }
                        }
                        delMktDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            dto.DeliverableMktDfnChange.Add(delMktDto);
                        }
                }
            }

            #endregion

            #region Deliverable Territory Defn Change

            if (report == ReportRequestType.DeliverableTerritoryDfnChange)
            {
                DeliverableTerritoryDfnDTO delTerritoryDto = new DeliverableTerritoryDfnDTO();
                List<DeliverableTerritoryDfnDTO> lstDelTerritoryDto = new List<DeliverableTerritoryDfnDTO>();
                dto.DeliverableTerritoryDfnChange = new List<DeliverableTerritoryDfnDTO>();
                var Territories = (from delverables in _db.DeliveryTerritory_History 
                                   where delverables.DeliverableId == Id && delverables.DeliverableVersion >= startversion && delverables.DeliverableVersion <= endVersion
                                   select new { delverables.DeliverableId, delverables.TerritoryId, delverables.DeliverableVersion, delverables.TerritoryVersion, }).Distinct().ToList();
                for (int version = startversion; version < endVersion; version++)
                {
                    //hasSettingChange = false;
                    var tempList1 = Territories.Where(x => x.DeliverableVersion == version).ToList();
                    var tempList2 = Territories.Where(x => x.DeliverableVersion == version + 1).ToList();
                    var deletedItem = tempList1.Where(a => !tempList2.Any(a1 =>  a1.TerritoryId == a.TerritoryId)).Distinct().ToList();
                    var insertedItem = tempList2.Where(a => !tempList1.Any(a1 => a1.TerritoryId == a.TerritoryId)).Distinct().ToList();

                        DateTime rt;
                        DateTime dtModifiedDate = DateTime.MinValue;
                        if (dto == null)
                            dto = new DeliverablesDTO();
                        foreach (var Territory in deletedItem)
                        {
                            delTerritoryDto = new DeliverableTerritoryDfnDTO();
                        if (_db.Territories.Where(x => x.Id == Territory.TerritoryId).FirstOrDefault() != null)
                        {
                            delTerritoryDto.TerritoryDefinitionName = _db.Territories.Where(x => x.Id == Territory.TerritoryId).FirstOrDefault().Name;
                        }
                        else if (_db.Territories_History.Where(x => x.TerritoryId == Territory.TerritoryId).FirstOrDefault() != null)
                        {
                           
                            delTerritoryDto.TerritoryDefinitionName = _db.Territories_History.Where(x => x.TerritoryId == Territory.TerritoryId).OrderByDescending(y => y.ModifiedDate).FirstOrDefault().Name;

                        }
                        delTerritoryDto.TerritoryDefnitionVersion = Territory.TerritoryVersion;
                            delTerritoryDto.VersionNumber = version +1;
                            delTerritoryDto.Action = "Deleted";
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delTerritoryDto.VersionNumber).FirstOrDefault() != null)
                        {
                            dtModifiedDate = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delTerritoryDto.VersionNumber).FirstOrDefault().ModifiedDate;
                        }
                        int userId = 0;
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delTerritoryDto.VersionNumber).FirstOrDefault() != null)
                        {
                             userId = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == delTerritoryDto.VersionNumber).FirstOrDefault().UserId;
                        }
                            var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                            if (userDetail != null)
                            {
                                delTerritoryDto.SubmittedBy = (!string.IsNullOrEmpty(userDetail.FirstName) ? userDetail.FirstName : string.Empty) + " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty); 
                            }
                            if (dtModifiedDate != null && DateTime.TryParse(dtModifiedDate.ToString(), out rt))
                            {
                            delTerritoryDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                                    //"dd/MM/yyyy HH:mm:ss");
                            }
                            dto.DeliverableTerritoryDfnChange.Add(delTerritoryDto);
                        }
                        foreach (var Territory in insertedItem)
                        {
                            delTerritoryDto = new DeliverableTerritoryDfnDTO();
                        if (_db.Territories.Where(x => x.Id == Territory.TerritoryId).FirstOrDefault() != null)
                        {
                            delTerritoryDto.TerritoryDefinitionName = _db.Territories.Where(x => x.Id == Territory.TerritoryId).FirstOrDefault().Name;
                        }
                        else if (_db.Territories_History.Where(x => x.TerritoryId == Territory.TerritoryId).FirstOrDefault() != null)
                        {
                            delTerritoryDto.TerritoryDefinitionName = _db.Territories_History.Where(x => x.TerritoryId == Territory.TerritoryId).FirstOrDefault().Name;
                        }
                        delTerritoryDto.TerritoryDefnitionVersion = Territory.TerritoryVersion;
                            delTerritoryDto.VersionNumber = Territory.DeliverableVersion;
                            delTerritoryDto.Action = "Added";
                        int userId = 0;
                        if (_db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == Territory.DeliverableVersion).FirstOrDefault() != null)
                        {
                            userId = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == Territory.DeliverableVersion).FirstOrDefault().UserId;
                            dtModifiedDate = _db.Deliverables_History.Where(x => x.DeliverableId == Id && x.Version == Territory.DeliverableVersion).FirstOrDefault().ModifiedDate;
                        }
                            var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                            if (userDetail != null)
                            {
                                delTerritoryDto.SubmittedBy = (!string.IsNullOrEmpty(userDetail.FirstName) ? userDetail.FirstName : string.Empty) + " " + (!string.IsNullOrEmpty(userDetail.LastName) ? userDetail.LastName : string.Empty); 
                            }
                            if (dtModifiedDate != null && DateTime.TryParse(dtModifiedDate.ToString(), out rt))
                            {
                            delTerritoryDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                                    //"dd/MM/yyyy HH:mm:ss");
                            }
                            dto.DeliverableTerritoryDfnChange.Add(delTerritoryDto);
                        }
                }
            }

            #endregion

            return dto;
        }

        private bool IsdeliveredToChanged ( int DeliverableId, int Version1, int Version2)
        {
            List<int> lstClient1 = _db.DeliveryClient_History.Where(d => d.DeliverableId == DeliverableId && d.DeliverableVersion == Version1).Select(d1 => d1.ClientId).ToList();
            List<int> lstClient2 = _db.DeliveryClient_History.Where(d => d.DeliverableId == DeliverableId && d.DeliverableVersion == Version2).Select(d1 => d1.ClientId).ToList();

            List<int> lstThirdParties1 = _db.DeliveryThirdParty_History.Where(d => d.DeliverableId == DeliverableId && d.DeliverableVersion == Version1).Select(d1 => d1.ThirdPartyId).ToList();
            List<int> lstThirdParties2 = _db.DeliveryThirdParty_History.Where(d => d.DeliverableId == DeliverableId && d.DeliverableVersion == Version2).Select(d1 => d1.ThirdPartyId).ToList();

            return ((!(lstClient1.SequenceEqual(lstClient2)) || (!(lstThirdParties1.SequenceEqual(lstThirdParties2)) )));
        }
       

        private string GetRestrictionNames (int DeliverableId, int? RestrictionId)
        {


            //var Territories = (from delverables in _db.DeliveryTerritories
            //                   where delverables.DeliverableId == DeliverableId
            //                   select new {delverables.TerritoryId }).Distinct().ToList();
            string Territories = string.Join(",", _db.DeliveryTerritories.Where(cl => (cl.DeliverableId == DeliverableId)).Select(c => c.TerritoryId).ToList());


            string LevelNames = string.Join(",", _db.Levels.Where( lvl => Territories.Contains(lvl.TerritoryId.ToString()) && lvl.LevelNumber == RestrictionId).Select (l => l.Name).Distinct().ToList());
                              // select new { delverables.TerritoryId }).Distinct().ToList();

            return LevelNames;
        }
       

    }

}


