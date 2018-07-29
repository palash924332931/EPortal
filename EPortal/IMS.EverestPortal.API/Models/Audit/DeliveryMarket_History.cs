using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("DeliveryMarket_History")]
    public class DeliveryMarket_History
    {
        public int Id { get; set; }
        public int DeliveryMarketId { get; set; }
        public int DeliverableId { get; set; }
        public int DeliverableVersion { get; set; }

        public int MarketDefId { get; set; }
        public int MarketDefVersion { get; set; }
        [ForeignKey("MarketDefId,MarketDefVersion")]
        public virtual MarketDefinitions_History MarketDefinitions_History { get; set; }
        //[ForeignKey("DeliverableId,DeliverableVersion")]
        //public virtual Deliverables_History Deliverables_History { get; set; }
    }
}