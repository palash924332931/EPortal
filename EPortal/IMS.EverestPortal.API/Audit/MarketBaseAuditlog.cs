using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketBaseAuditlog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 1;
            MarketBase val = (MarketBase)(object)cName;

            var result = _db.MarketBase_History.Where(i => i.MBId == val.Id).OrderByDescending(x => x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;

            MarketBase_History MB_History = new MarketBase_History();
            BaseFilter_History BF_History = null;
            val.CopyProperties(MB_History);

            MB_History.ModifiedDate = DateTime.Now;
            MB_History.UserId = UserId;
            MB_History.Version = Version;
            MB_History.MBId = val.Id;

            

            foreach (BaseFilter filter in val.Filters)
            {
                BF_History = new BaseFilter_History();
                filter.CopyProperties(BF_History);
                BF_History.MarketBaseVersion = Version;
                BF_History.MarketBaseMBId = filter.MarketBaseId;
                if (MB_History.Filters == null)
                    MB_History.Filters = new List<BaseFilter_History>();
                MB_History.Filters.Add(BF_History);


            }

            _db.MarketBase_History.Add(MB_History);
            _db.SaveChanges();

        }
    }
}