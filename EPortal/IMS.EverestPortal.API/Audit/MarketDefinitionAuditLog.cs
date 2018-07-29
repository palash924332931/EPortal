using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketDefinitionAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 0;
            MarketDefinition val = (MarketDefinition)(object)cName;

            var result = _db.MarketDefinitions_History.Where(i => i.MarketDefId == val.Id).OrderByDescending(x=>x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;
            MarketDefinitions_History obj = new MarketDefinitions_History();

            val.CopyProperties(obj);
            obj.MarketDefId = val.Id;
            obj.Version = Version;
            obj.ModifiedDate = DateTime.Now;
            obj.UserId = UserId;

            foreach (MarketDefinitionBaseMap baseMap in val.MarketDefinitionBaseMaps)
            {
                MarketDefBaseMap_History baseObj = new MarketDefBaseMap_History();
                baseMap.CopyProperties(baseObj);
                baseObj.MarketDefId = val.Id;
                baseObj.Version = Version;
                var mbData = _db.MarketBase_History.Where(b => b.MBId == baseMap.MarketBaseId).OrderByDescending(o => o.Version).FirstOrDefault();
                baseObj.MarketBaseVersion = (mbData==null)? 1:mbData.Version;

                foreach (AdditionalFilter addFilter in baseMap.Filters)
                {
                    AdditionalFilter_History addFilterHistory = new AdditionalFilter_History();
                    addFilter.CopyProperties(addFilterHistory);
                    addFilterHistory.MarketDefVersion = Version;

                    if (baseObj.Filters == null)
                        baseObj.Filters = new List<AdditionalFilter_History>();
                    baseObj.Filters.Add(addFilterHistory);

                }

                if (obj.MarketDefBaseMap_History == null)
                    obj.MarketDefBaseMap_History = new List<MarketDefBaseMap_History>();
                obj.MarketDefBaseMap_History.Add(baseObj);
            }

            foreach (MarketDefinitionPack pack in val.MarketDefinitionPacks)
            {
                MarketDefPack_History packHistory = new MarketDefPack_History();
                packHistory.MarketDefVersion = Version;

                pack.CopyProperties(packHistory);

                if (obj.MarketDefPack_History == null)
                    obj.MarketDefPack_History = new List<MarketDefPack_History>();
                obj.MarketDefPack_History.Add(packHistory);
            }

            //obj.MarketDefId = val.Id;
            //obj.Version = Version;
            //obj.Name = val.Name;
            //obj.ModifiedDate = DateTime.Now;
            //obj.ClientId = val.ClientId;
            //obj.Description = val.Description;
            //obj.UserId = UserId;

            //MarketDefBaseMap_History baseObj = new MarketDefBaseMap_History();

            //foreach(MarketDefinitionBaseMap baseMap in val.MarketDefinitionBaseMaps)
            //{
            //    baseObj = new MarketDefBaseMap_History();
            //    baseObj.Id = baseMap.Id;
            //    baseObj.MarketBaseId = baseMap.MarketBaseId;
            //    baseObj.MarketBaseVersion = 1;
            //    baseObj.MarketDefId = val.Id; 
            //    baseObj.Version = Version;
            //    baseObj.Name = baseMap.Name;
            //    baseObj.DataRefreshType = baseMap.DataRefreshType;

            //    foreach(AdditionalFilter addFilter in baseMap.Filters)
            //    {
            //        AdditionalFilter_History addFilterHistory = new AdditionalFilter_History();
            //        addFilterHistory.Criteria = addFilter.Criteria;
            //        addFilterHistory.Id = addFilter.Id;
            //        addFilterHistory.IsEnabled = addFilter.IsEnabled;
            //        addFilterHistory.MarketDefBaseMap_HistoryId = addFilter.MarketDefinitionBaseMapId;
            //        addFilterHistory.MarketDefVersion = Version;
            //        addFilterHistory.Values = addFilter.Values;
            //        addFilterHistory.Name = addFilter.Name;
            //        //if (baseObj.Filters == null)
            //        //    baseObj.Filters = new List<AdditionalFilter_History>();
            //        //baseObj.Filters.Add(addFilterHistory);
            //    }
            //    if (obj.MarketDefBaseMap_History == null)
            //        obj.MarketDefBaseMap_History = new List<MarketDefBaseMap_History>();
            //    obj.MarketDefBaseMap_History.Add(baseObj);
            //}

            //MarketDefPack_History packHistory = new MarketDefPack_History();

            //foreach(MarketDefinitionPack pack in val.MarketDefinitionPacks)
            //{
            //    packHistory = new MarketDefPack_History();
            //    packHistory.Alignment = pack.Alignment;
            //    packHistory.ATC4 = pack.ATC4;
            //    packHistory.ChangeFlag = pack.ChangeFlag;
            //    packHistory.DataRefreshType = pack.DataRefreshType;
            //    packHistory.Factor = pack.Factor;
            //    packHistory.Id = pack.Id;
            //    packHistory.Manufacturer = pack.Manufacturer;
            //    packHistory.MarketBaseId = pack.MarketBaseId;
            //    packHistory.MarketDefVersion = Version;
            //    packHistory.MarketDefinitionId = pack.MarketDefinitionId;
            //    packHistory.Molecule = pack.Molecule;
            //    packHistory.NEC4 = pack.NEC4;
            //    packHistory.PFC = pack.PFC;
            //    packHistory.Product = pack.Product;
            //    if (obj.MarketDefPack_History == null)
            //        obj.MarketDefPack_History = new List<MarketDefPack_History>();
            //    obj.MarketDefPack_History.Add(packHistory);
            //}

            _db.MarketDefinitions_History.Add(obj);
            _db.SaveChanges();

        }
    }
}