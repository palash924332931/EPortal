using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Subscription
{
    [Table("ClientSubscription")]
    public class ClientSubscription
    {
        public int ClientSubscriptionId { get; set; }
        public int ClientId { get; set; }
        public int SubscriptionId { get; set; }

        public virtual Subscription subscription { get; set; }
        public virtual Client client { get; set; }
    }
}