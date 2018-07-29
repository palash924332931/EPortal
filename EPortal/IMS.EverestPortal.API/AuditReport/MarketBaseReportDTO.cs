using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class MarketBaseReportDTO
    {
        public List<MarketNameChangeDTO> MarketNameChange { get; set; }
        public List<MarketSettingsChangeDTO> MarketSettingsChange { get; set; }
    }

    public class MarketNameChangeDTO
    {
        public string Name { get; set; }
        public int Version { get; set; }
        public string ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
    }

    public class MarketSettingsChangeDTO
    {
        public string MarketbaseName { get; set; }
        public string Setting { get; set; }
        public int Version { get; set; }
        public int PackCount { get; set; }
        public string ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
    }
}