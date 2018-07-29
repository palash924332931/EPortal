using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API
{
    public class MarketDefBaseMapChanges
    {
        public string MBName { get; set; }
        public string DataRefreshSettings { get; set; }
        public string Filter { get; set; }
        public string Action { get; set; }
        public int Version { get; set; }
        public string SubmittedBy { get; set; }
        public DateTime DateTime { get; set; }
    }
}