using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public static class ReportRequestType
    {
        public const string MarketBaseNameChange = "MarketBaseNameChange";
        public const string MarketBaseSettingChange = "MarketBaseSettingChange";
        public const string SubscriptionPeriodChange = "Period Changes";
        public const string SubscriptionMktbaseChange = "Market Base Changes";
        public const string DeliverableReportParameterChange = "Report Parameter Changes";
        public const string DeliverableMktDfnChange = "Market Definition Changes";
        public const string DeliverableTerritoryDfnChange = "Territory Definition Changes";
        public const string TerritoryDefinitionChange = "TerritoryDefinitionChange";
        public const string TerritoryAllocationChange = "TerritoryAllocationChange";


        // ['Report Parameter Changes', 'Market Definition Changes', 'Territory Definition Changes'];
        // DeliverableReportParameterChange




    }
}