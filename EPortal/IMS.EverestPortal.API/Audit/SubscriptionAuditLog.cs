using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Subscription;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class SubscriptionAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 1;
            Subscription val = (Subscription)(object)cName;

            var result = _db.Subscription_History.Where(i => i.SubscriptionId == val.SubscriptionId).OrderByDescending(x => x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;

            Subscription_History S_History = new Subscription_History();
            SubscriptionMarket_History SM_History = null;
            val.CopyProperties(S_History);

            S_History.ModifiedDate = DateTime.UtcNow;
            S_History.UserId = UserId;
            S_History.Version = Version;
            S_History.LastSaved = val.LastModified;
            S_History.SubscriptionId = val.SubscriptionId;

            var subMarket = _db.subscriptionMarket.Where(sm => sm.SubscriptionId == val.SubscriptionId).ToList();


            foreach(SubscriptionMarket smData in subMarket)
            {
                SM_History = new SubscriptionMarket_History();
                smData.CopyProperties(SM_History);
                var marketBase = _db.MarketBase_History.Where(mb => mb.MBId == smData.MarketBaseId).OrderByDescending(x => x.Version).FirstOrDefault();
                SM_History.MarketBaseVersion = (marketBase == null) ? 1 : marketBase.Version;
                SM_History.SubscriptionVersion = Version;

                if (S_History.SubscriptionMarket_History == null)
                    S_History.SubscriptionMarket_History = new List<SubscriptionMarket_History>();
                S_History.SubscriptionMarket_History.Add(SM_History);
            }

            _db.Subscription_History.Add(S_History);
            _db.SaveChanges();
        }
    }
}