using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Audit
{
    public class MarketDefNameChanges
    {
        public string MarketDefName { get; set; }
        public int VersionNumber { get; set; }
        public string SubmittedBy { get; set; }
        public DateTime DateTime { get; set; }
    }
}