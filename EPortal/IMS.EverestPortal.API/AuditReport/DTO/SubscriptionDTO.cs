using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.AuditReport
{
    public class SubscriptionDTO
    {

         public List<SubscriptionPeriodChangeDTO> SubscriptionPeriodChange { get; set; }
        public List<SubscriptionMktBaseNamEChangeDTO> SubscriptionMktBaseNamEChange { get; set; }
    }



    public class SubscriptionPeriodChangeDTO : AuditDTO
    {
        public string DataSubscriptionPeriod { get; set; }
    }

    public class SubscriptionMktBaseNamEChangeDTO : AuditDTO
    {
        public string MarketBaseName { get; set; }
        public int MarketBaseVersion { get; set; }
        public string Action { get; set; }
    }


}