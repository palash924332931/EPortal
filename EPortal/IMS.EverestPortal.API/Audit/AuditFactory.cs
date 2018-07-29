using IMS.EverestPortal.API.Models;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Report;
using IMS.EverestPortal.API.Models.Security;
using IMS.EverestPortal.API.Models.Subscription;
using IMS.EverestPortal.API.Models.Territory;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;


namespace IMS.EverestPortal.API.Audit
{
    public static class AuditFactory
    {
        public static IAuditLog GetInstance(string className)
        {
            bool diableAudit = Convert.ToBoolean(ConfigurationManager.AppSettings["DisableAudit"].ToString());
            IAuditLog obj = null;
            if(diableAudit)
                return new DummyAudit();

            if (typeof(MarketDefinition).Name == className)
                return new MarketDefinitionAuditLog();

            if (typeof(MarketBase).Name == className)
                return new MarketBaseAuditlog();

            if (typeof(Territory).Name == className)
                return new TerritoryAuditLog();

            if (typeof(User).Name == className)
                return new UserAuditLog();

            if (typeof(Subscription).Name == className)
                return new SubscriptionAuditLog();

            if (typeof(ReportFilter).Name == className)
                return new ReportFilterAuditLog();

            if (typeof(Deliverables).Name == className)
                return new DeliveryAuditLog();

            return obj;
        }

    }
}