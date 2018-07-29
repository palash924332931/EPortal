using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class DifferenceClass
    {
        public string PropName { get; set; }
        public object valA { get; set; }
        public object valB { get; set; }
    }
}