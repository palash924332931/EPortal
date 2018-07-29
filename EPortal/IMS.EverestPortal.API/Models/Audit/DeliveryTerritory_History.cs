using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Models
{
    [Table("DeliveryTerritory_History")]
    public class DeliveryTerritory_History
    {
        public int Id { get; set; }
        public int DeliveryTerritoryId { get; set; }
        public int DeliverableId { get; set; }
        public int DeliverableVersion { get; set; }
        public int TerritoryId { get; set; }
        public int TerritoryVersion { get; set; }

        //[ForeignKey("DeliverableId,DeliverableVersion")]
        //public virtual Deliverables_History Deliverables_History { get; set; }
        [ForeignKey("TerritoryId,TerritoryVersion")]
        public virtual Territories_History Territories_History { get; set; }
    }
}