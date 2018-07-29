using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class MarketBaseReport : IAuditReport
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public dynamic GenerateReport(int Id, int startversion, int endVersion, string report)
        {
            var result = _db.MarketBase_History.Where(i => i.MBId == Id).Where(x => x.Version >= startversion && x.Version <= endVersion).ToList();
            MarketBaseReportDTO dto = new MarketBaseReportDTO();
            List<string> nameChangeParm = new List<string>() { "Name", "Suffix" };
            List<string> settingsChangeParm = new List<string>() { "Name", "Values" };
            bool hasSettingChange = false;
            if (report == ReportRequestType.MarketBaseNameChange)
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
                            MarketNameChangeDTO diff = new MarketNameChangeDTO();
                            diff.Name = item1.Name + " " + item1.Suffix;
                            diff.Version = item1.Version;
                            var userDetail = _db.Users.Where(a => a.UserID == item1.UserId).FirstOrDefault();
                            diff.ChangeUser = userDetail.FirstName + " " + userDetail.LastName;
                            diff.ChangeDate = item1.ModifiedDate;

                            if (dto.MarketNameChange == null)
                                dto.MarketNameChange = new List<MarketNameChangeDTO>();
                            dto.MarketNameChange.Add(diff);

                            diff = new MarketNameChangeDTO();
                            diff.Name = item2.Name + " " + item2.Suffix;
                            diff.Version = item2.Version;
                            userDetail = _db.Users.Where(a => a.UserID == item2.UserId).FirstOrDefault();
                            diff.ChangeUser = userDetail.FirstName + " " + userDetail.LastName;
                            diff.ChangeDate = item2.ModifiedDate;
                            dto.MarketNameChange.Add(diff);
                        }
                    }
                }
            }

           

            if (report == ReportRequestType.MarketBaseSettingChange)
            {
                for (int i = 1; i < result.Count; i++)
                {
                    hasSettingChange = false;
                    var tempList1 = result[i - 1].Filters;
                    var tempList2 = result[i].Filters;

                    var deletedItem = tempList1.Where(a => !tempList2.Any(a1 => a1.Name == a.Name));
                    var insertedItem = tempList2.Where(a => !tempList1.Any(a1 => a1.Name == a.Name));

                    MarketSettingsChangeDTO settingDto1 = new MarketSettingsChangeDTO();
                    settingDto1.MarketbaseName = result[i - 1].Name + " " + result[i - 1].Suffix;
                    foreach (BaseFilter_History BF1 in deletedItem)
                    {
                        settingDto1.Setting += BF1.Name + "=" + BF1.Values + ",";
                        hasSettingChange = true;
                    }
                    settingDto1.Version = result[i - 1].Version;
                    
                    settingDto1.ChangeDate = result[i - 1].ModifiedDate;
                                        

                    MarketSettingsChangeDTO settingDto2 = new MarketSettingsChangeDTO();
                    settingDto2.MarketbaseName = result[i].Name + " " + result[i].Suffix;
                    foreach (BaseFilter_History BF2 in insertedItem)
                    {
                        settingDto1.Setting += BF2.Name + "=" + BF2.Values + ",";
                        hasSettingChange = true;
                    }
                    settingDto2.Version = result[i].Version;
                   
                    settingDto2.ChangeDate = result[i].ModifiedDate;
                                      

                    foreach (BaseFilter_History BF1 in tempList1)
                    {
                        var BF2 = tempList2.FirstOrDefault(x => x.Name == BF1.Name);

                        if (BF2 == null)
                            continue;
                        var diffList = BF1.GetObjectDifference(BF2, settingsChangeParm);

                        if (diffList.Count >= 1 || hasSettingChange)
                        {

                            settingDto1.Setting += BF1.Name + "=" + BF1.Values + ",";
                            
                            
                            settingDto2.Setting += BF2.Name+"="+ BF2.Values + ",";

                            hasSettingChange = true;


                        }
                    }

                    

                    if (dto.MarketSettingsChange == null)
                        dto.MarketSettingsChange = new List<MarketSettingsChangeDTO>();

                    if (hasSettingChange)
                    {
                        int userid = result[i - 1].UserId;
                        var userDetail = _db.Users.Where(a => a.UserID == userid).FirstOrDefault();
                        settingDto1.ChangeUser = userDetail.FirstName + " " + userDetail.LastName;
                        SqlParameter p1 = new SqlParameter("@MarketBaseId", result[i - 1].MBId);
                        SqlParameter p2 = new SqlParameter("@Version", result[i - 1].Version);
                        var res1 = _db.Database.SqlQuery<MarketBasePack>("exec GetPacksFromMarketBaseHistory " + result[i - 1].MBId + "," + result[i - 1].Version, p1, p2).ToList();
                        settingDto1.PackCount = res1.Count();

                        userid = result[i].UserId;
                        userDetail = _db.Users.Where(a => a.UserID == userid).FirstOrDefault();
                        settingDto2.ChangeUser = userDetail.FirstName + " " + userDetail.LastName;
                        p1 = new SqlParameter("@MarketBaseId", result[i].MBId);
                        p2 = new SqlParameter("@Version", result[i].Version);
                        var res2 = _db.Database.SqlQuery<MarketBasePack>("exec GetPacksFromMarketBaseHistory " + result[i].MBId + "," + result[i].Version, p1, p2).ToList();
                        settingDto2.PackCount = res2.Count;

                        dto.MarketSettingsChange.Add(settingDto1);
                        dto.MarketSettingsChange.Add(settingDto2);
                    }
                }

            }
            return dto;
        }
    }

    class MarketBasePack
    {
        public string PFC { get; set; }
        public int FCC { get; set; }
    }
}