using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Deliverable;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class DeliveryAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 1;
            Deliverables val = (Deliverables)(object)cName;
            Deliverables_History DHistory = new Deliverables_History();
            var result = _db.Deliverables_History.Where(i => i.DeliverableId == val.DeliverableId).OrderByDescending(x => x.Version).ToList().FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;
            using (var transaction = _db.Database.BeginTransaction())
            {

                val.CopyProperties(DHistory);

                DHistory.Version = Version;
                DHistory.ModifiedDate = DateTime.Now;
                DHistory.UserId = UserId;
                DHistory.LastSaved = val.LastModified;

                _db.Deliverables_History.Add(DHistory);
                //_db.SaveChanges();

                var DClientlst = _db.DeliveryClients.Where(c => c.DeliverableId == val.DeliverableId);

                DeliveryClient_History DC_History = null;
                foreach (DeliveryClient DC in DClientlst)
                {
                    DC_History = new DeliveryClient_History();
                    DC.CopyProperties(DC_History);
                    DC_History.DeliverableVersion = Version;

                    _db.DeliveryClient_History.Add(DC_History);
                    //_db.SaveChanges();
                }

                var DMarketlst = _db.DeliveryMarkets.Where(m => m.DeliverableId == val.DeliverableId).ToList();

                DeliveryMarket_History DM_History = null;
                foreach (DeliveryMarket DM in DMarketlst)
                {
                    DM_History = new DeliveryMarket_History();
                    DM.CopyProperties(DM_History);
                    DM_History.DeliverableVersion = Version;
                    var temp = _db.MarketDefinitions_History.Where(d => d.MarketDefId == DM.MarketDefId).OrderByDescending(x => x.Version).ToList().FirstOrDefault();
                    DM_History.MarketDefVersion = (temp == null) ? 1 : temp.Version;

                    _db.DeliveryMarket_History.Add(DM_History);
                    //_db.SaveChanges();
                }

                var DTerritorylst = _db.DeliveryTerritories.Where(t => t.DeliverableId == val.DeliverableId).ToList();

                DeliveryTerritory_History DT_History = null;
                foreach (DeliveryTerritory DT in DTerritorylst)
                {
                    DT_History = new DeliveryTerritory_History();
                    DT.CopyProperties(DT_History);
                    DT_History.DeliverableVersion = Version;
                    var temp = _db.Territories_History.Where(t => t.TerritoryId == DT.TerritoryId).OrderByDescending(x => x.Version).ToList().FirstOrDefault();
                    DT_History.TerritoryVersion = (temp == null) ? 1 : temp.Version;

                    _db.DeliveryTerritory_History.Add(DT_History);
                    //_db.SaveChanges();
                }

                var DThirdPartylst = _db.DeliveryThirdParties.Where(p => p.DeliverableId == val.DeliverableId).ToList();

                DeliveryThirdParty_History DTP_History = null;
                foreach (DeliveryThirdParty DP in DThirdPartylst)
                {
                    DTP_History = new DeliveryThirdParty_History();
                    DP.CopyProperties(DTP_History);
                    DTP_History.DeliverableVersion = Version;

                    _db.DeliveryThirdParty_History.Add(DTP_History);
                    //_db.SaveChanges();
                }

                _db.SaveChanges();
                transaction.Commit();
            }

        }
    }
}