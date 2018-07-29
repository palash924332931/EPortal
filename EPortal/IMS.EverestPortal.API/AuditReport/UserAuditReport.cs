using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class UserAuditReport : IAuditReport
    { 
        public dynamic GenerateReport(int Id, int startversion, int endVersion, string report)
        {
            throw new NotImplementedException();
        }
    }
}