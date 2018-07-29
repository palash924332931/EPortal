using IMS.EverestPortal.API.DAL;
using System.Collections.Generic;
using System.Linq;
using IMS.EverestPortal.API.Models;
using System;

namespace IMS.EverestPortal.API.AuditReport
{
    
    public class SubscriptionReport : IAuditReport
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public dynamic GenerateReport(int Id, int startversion, int endVersion, string report)
        {
            List<string> nameChangeParm = new List<string>() { "StartDate", "EndDate" };
            SubscriptionDTO dto = new SubscriptionDTO();
            List<Subscription_History> result = _db.Subscription_History.Where(i => i.SubscriptionId == Id).Where(x => x.Version >= startversion && x.Version <= endVersion).ToList();

            #region SubscriptionPeriodChange
                if (report == ReportRequestType.SubscriptionPeriodChange)
                {
                    if (result.Count > 1)
                    {
                    for (int i = 1; i < result.Count; i++)
                    {
                        var item1 = result[i - 1];
                        var item2 = result[i];
                        var diffList = item1.GetObjectDifference(item2, nameChangeParm);

                        if (diffList.Count >= 1)
                        {
                            SubscriptionPeriodChangeDTO diff = new SubscriptionPeriodChangeDTO();
                            diff.DataSubscriptionPeriod = item1.StartDate.ToString("MMM-yyyy") + " ~ " + item1.EndDate.ToString("MMM-yyyy");
                            diff.VersionNumber = item1.Version;
                            var userDetail = _db.Users.Where(a => a.UserID == item1.UserId).FirstOrDefault();
                            diff.SubmittedBy = userDetail.FirstName + " " + userDetail.LastName;
                            diff.DateTime = item1.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                                //("dd/MM/yyyy HH:mm:ss");
                            if (dto.SubscriptionPeriodChange == null)
                            {
                                dto.SubscriptionPeriodChange = new List<SubscriptionPeriodChangeDTO>();
                            }
                            int iCnt = dto.SubscriptionPeriodChange.Where(a => a.VersionNumber == item1.Version).Count();
                            if (iCnt == 0)
                            {
                                dto.SubscriptionPeriodChange.Add(diff);
                            }

                            diff = new SubscriptionPeriodChangeDTO();
                            // diff.StartDate = item2.StartDate;
                            diff.DataSubscriptionPeriod = item2.StartDate.ToString("MMM-yyyy") + " ~ " + item2.EndDate.ToString("MMM-yyyy");
                            //  diff.EndDate = item2.EndDate.ToString("MMM-yyyy");
                            diff.VersionNumber = item2.Version;
                            userDetail = _db.Users.Where(a => a.UserID == item2.UserId).FirstOrDefault();
                            diff.SubmittedBy = userDetail.FirstName + " " + userDetail.LastName;
                            diff.DateTime = item2.ModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                                //("dd/MM/yyyy HH:mm:ss");

                            dto.SubscriptionPeriodChange.Add(diff);
                        }
                    }
                          }
                        }
                    
                
                #endregion

            #region SubscriptionMktbaseChange

                if (report == ReportRequestType.SubscriptionMktbaseChange)
                {
                    SubscriptionMktBaseNamEChangeDTO subMktDto = new SubscriptionMktBaseNamEChangeDTO();
                    List<SubscriptionMktBaseNamEChangeDTO> lstsubMktDto = new List<SubscriptionMktBaseNamEChangeDTO>();
                
                    var MarketBases = (from  sm in _db.SubscriptionMarket_History 
                                                        where sm.SubscriptionId == Id && sm.SubscriptionVersion >= startversion && sm.SubscriptionVersion <= endVersion
                                                        select new { sm.SubscriptionVersion, sm.SubscriptionId, sm.MarketBaseId, sm.MarketBaseVersion }).Distinct().ToList();
                
                        if (dto.SubscriptionMktBaseNamEChange == null)
                        {
                            dto.SubscriptionMktBaseNamEChange = new List<SubscriptionMktBaseNamEChangeDTO>();
                        }
                        for (int version = startversion; version < endVersion; version++)
                        {
                        //hasSettingChange = false;
                        var tempList1 = MarketBases.Where(x => x.SubscriptionVersion == version).OrderBy(m => m.MarketBaseId).Distinct().ToList();
                        var tempList2 = MarketBases.Where(x => x.SubscriptionVersion == version + 1).OrderBy(m => m.MarketBaseId).Distinct().ToList();
                        //if (tempList1.Count > 0 && tempList2.Count > 0)
                        //{
                            var deletedItem = tempList1.Where(a => !tempList2.Any(a1 => a1.MarketBaseId == a.MarketBaseId)).Distinct().ToList();
                            var insertedItem = tempList2.Where(a => !tempList1.Any(a1 => a1.MarketBaseId == a.MarketBaseId)).Distinct().ToList();

                    //int userId = _db.Subscription_History.Where(x => x.SubscriptionId == Id).FirstOrDefault().UserId;
                            DateTime dtModifiedDate = DateTime.MinValue;
                         foreach (var mkt in deletedItem)
                            {

                                    subMktDto = new SubscriptionMktBaseNamEChangeDTO();
                                    MarketBase mktBase = _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault();

                                    if (mktBase != null)
                                    {
                                        subMktDto.MarketBaseName += _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault().Name + "  " + _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault().Suffix;
                                    }
                                    subMktDto.MarketBaseVersion = mkt.MarketBaseVersion;
                                    subMktDto.VersionNumber = version +1;
                                    subMktDto.Action = "Deleted";
                                    if (_db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault() != null)
                                    {
                                        dtModifiedDate = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault().ModifiedDate;
                                    }

                                    Subscription_History sHistory = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault();
                                    if (sHistory != null)
                                    {
                                        int userId = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault().UserId;
                                        var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                                        subMktDto.SubmittedBy = userDetail.FirstName + " " + userDetail.LastName;
                                    }
                                    subMktDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            //("dd/MM/yyyy HH:mm:ss");
                                    dto.SubscriptionMktBaseNamEChange.Add(subMktDto);
                                }
                       
                                foreach (var mkt in insertedItem)
                                {
                                    subMktDto = new SubscriptionMktBaseNamEChangeDTO();
                                    MarketBase mktBase = _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault();
                                  
                                    if (mktBase != null)
                                    {
                                        subMktDto.MarketBaseName += _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault().Name + "  " + _db.MarketBases.Where(x => x.Id == mkt.MarketBaseId).FirstOrDefault().Suffix;
                                    }
                                    subMktDto.MarketBaseVersion = mkt.MarketBaseVersion;
                                    subMktDto.VersionNumber = mkt.SubscriptionVersion;

                                    subMktDto.Action = "Added";
                                    if (_db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault() != null)
                                    {
                                        dtModifiedDate = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault().ModifiedDate;
                                    }
                                    Subscription_History sHistory = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault();
                                    if (sHistory != null)
                                    {
                                        int userId = _db.Subscription_History.Where(x => x.SubscriptionId == Id && x.Version == subMktDto.VersionNumber).FirstOrDefault().UserId;
                                        var userDetail = _db.Users.Where(a => a.UserID == userId).FirstOrDefault();
                                        subMktDto.SubmittedBy = userDetail.FirstName + " " + userDetail.LastName;
                                    }
                                    subMktDto.DateTime = dtModifiedDate.ToString("yyyy-MM-dd hh:mm:ss");
                            //("dd/MM/yyyy HH:mm:ss");
                                     dto.SubscriptionMktBaseNamEChange.Add(subMktDto);
                                }
                           // }
                        }
                   // }
                }

                #endregion
                    
            return dto;
        }

    }

}


