using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketDefGroupChanges
    {
        public string PFC { get; set; }
        public string GroupName { get; set; }
        public string MarketAttribute { get; set; }
        public string Action { get; set; }
        public string PackDescription { get; set; }
        public int Version { get; set; }
        public string SubmittedBy { get; set; }
        public DateTime DateTime { get; set; }
    }
}