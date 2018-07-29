using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class DummyAudit : IAuditLog
    {
        public void SaveVersion<T>(T cName, int UserId)
        {
            //Do nothing
        }
    }
}