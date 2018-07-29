using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class DeliverablesDTO 
    {

        public List<DeliverableReportParameterChangeDTO> DeliverableReportParameterChange { get; set; }
        public List<DeliverableMktDfnDTO> DeliverableMktDfnChange { get; set; }

        public List<DeliverableTerritoryDfnDTO> DeliverableTerritoryDfnChange { get; set; }
    }

        public class DeliverableReportParameterChangeDTO : AuditDTO
        {
            public string DataDeliveryPeriod { get; set; }
           // public string StartDate { get; set; }
           //public string EndDate { get; set; }
           public string Frequency { get; set; }
           public string Period { get; set; }
           public string Restriction { get; set; }
           public string ReportWriter { get; set; }
           public string DeliveredTo { get; set; }
           public string PROBE{ get; set; }
           public string Census { get; set; }
           public string One_Key { get; set; }
           public string PackException { get; set; }

    }

    public class DeliverableMktDfnDTO : AuditDTO
    {
            public string MarketDefinitionName { get; set; }
            public int MarketDefnitionVersion { get; set; }
            public string Action { get; set; }
    }

    public class DeliverableTerritoryDfnDTO : AuditDTO
    {
        public string TerritoryDefinitionName { get; set; }
        public int TerritoryDefnitionVersion { get; set; }
        public string Action { get; set; }
    }

}