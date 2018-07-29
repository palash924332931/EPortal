using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("DeliveryMarket")]
    public class DeliveryMarket
    {
        public int DeliveryMarketId { get; set; }
        public int DeliverableId { get; set; }
        [ForeignKey("marketDefinition")]
        public int MarketDefId { get; set; }

        public virtual MarketDefinition marketDefinition { get; set; }
        public virtual Deliverables deliverables { get; set; }
    }
}