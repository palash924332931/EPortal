using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    public class SubscriptionMarket_History
    {
        public int Id { get; set; }
        public int SubscriptionMarketId { get; set; }
        public int SubscriptionId { get; set; }
        public int SubscriptionVersion { get; set; }
        public int MarketBaseId { get; set; }
        public int MarketBaseVersion { get; set; }
        [ForeignKey("MarketBaseId,MarketBaseVersion")]
        public virtual MarketBase_History marketBase { get; set; }
        
        [ForeignKey("SubscriptionId,SubscriptionVersion")]
        public virtual Subscription_History subscription { get; set; }
    }
}