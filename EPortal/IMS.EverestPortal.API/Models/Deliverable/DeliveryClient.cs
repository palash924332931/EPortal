using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("DeliveryClient")]
    public class DeliveryClient
    {
        public int DeliveryClientId { get; set; }
        public int DeliverableId { get; set; }
        public int ClientId { get; set; }

        public virtual Deliverables deliverables { get; set; }
        public virtual Client client { get; set; }
    }
}