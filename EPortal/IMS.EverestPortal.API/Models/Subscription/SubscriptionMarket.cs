using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("SubscriptionMarket")]
    public class SubscriptionMarket
    {
        public int SubscriptionMarketId { get; set; }
        public int SubscriptionId { get; set; }
        public int MarketBaseId { get; set; }

        public virtual MarketBase marketBase { get; set; }
        public virtual Subscription subscription { get; set; }
    }
}