using IMS.EverestPortal.API.DAL;
using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class ReportFilterAuditLog : IAuditLog
    {
        private EverestPortalContext _db = new EverestPortalContext();
        public void SaveVersion<T>(T cName, int UserId)
        {
            int Version = 1;
            ReportFilter val = (ReportFilter)(object)cName;

            var result = _db.ReportFilter_History.Where(i => i.FilterID == val.FilterID).OrderByDescending(x => x.Version).FirstOrDefault();
            Version = (result == null) ? 1 : result.Version + 1;

            ReportFilter_History rfHistory = new ReportFilter_History();
            val.CopyProperties(rfHistory);
            rfHistory.Version = Version;
            rfHistory.ModifiedDate = DateTime.Now;
            rfHistory.UserId = UserId;
            rfHistory.FilterID = val.FilterID;


            _db.ReportFilter_History.Add(rfHistory);
            _db.SaveChanges();

        }
    }
}