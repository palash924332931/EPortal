using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public abstract class AuditDTO
    {
        public int VersionNumber { get; set; }
        public string SubmittedBy { get; set; }
        public string DateTime { get; set; }
    }
}