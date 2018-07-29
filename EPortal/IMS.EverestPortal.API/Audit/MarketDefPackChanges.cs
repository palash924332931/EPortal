using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketDefPackChanges
    {        
        public string PFC { get; set; }
        public string PackDescription { get; set; }
        public string Action { get; set; }
        public string MarketBase { get; set; }
        public string Groups { get; set; }
        public string Factor { get; set; }
        public int Version { get; set; }
        public string ActionBy { get; set; }
        public DateTime DateTime { get; set; }
    }
}