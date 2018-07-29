using IMS.EverestPortal.API.Models.Deliverable;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("DeliveryThirdParty_History")]
    public class DeliveryThirdParty_History
    {
        public int Id { get; set; }
        public int DeliveryThirdPartyId { get; set; }
        public int DeliverableId { get; set; }
        public int DeliverableVersion { get; set; }
        public int ThirdPartyId { get; set; }

        //[ForeignKey("DeliverableId,DeliverableVersion")]
        //public virtual Deliverables_History Deliverables_History { get; set; }
       // [ForeignKey("ThirdPartyId")]
        //public virtual ThirdParty thirdParty { get; set; }
    }
}