using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models.Deliverable
{
    [Table("DeliveryThirdParty")]
    public class DeliveryThirdParty
    {
        public int DeliveryThirdPartyId { get; set; }
        public int DeliverableId { get; set; }
        public int ThirdPartyId { get; set; }

        public virtual Deliverables deliverables { get; set; }
        public virtual ThirdParty thirdParty { get; set; }
    }
   
}