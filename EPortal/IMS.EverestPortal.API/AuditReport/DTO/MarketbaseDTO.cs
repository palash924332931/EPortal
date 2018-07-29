using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport.DTO
{
    public class MarketbaseDTO
    {        
            public string MarketBaseName { get; set; }
            public string Settings { get; set; }
            public int? VersionNumber { get; set; }
            public string SubmittedBy { get; set; }
            public DateTime? DateTime { get; set; }
            public int? PackCount { get; set; }
    }
}