using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("DeliveryClient_History")]
    public class DeliveryClient_History
    {
        public int Id { get; set; }
        public int DeliveryClientId { get; set; }
        public int DeliverableId { get; set; }
        public int DeliverableVersion { get; set; }
        public int ClientId { get; set; }

       // [ForeignKey("DeliverableId,DeliverableVersion")]
       // public virtual Deliverables_History Deliverables_History { get; set; }
        //public virtual Client client { get; set; }
    }
}